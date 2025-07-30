from flask import Flask, request, render_template, redirect,jsonify
import requests
import time
import random
from flask_sqlalchemy import SQLAlchemy
from models import db, ShoppingItem

app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://myuser:mypassword@db:5432/mydb'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db.init_app(app)

@app.before_first_request
def create_tables():
    db.create_all()

@app.route("/debug-routes")
def debug_routes():
    routes = []
    for rule in app.url_map.iter_rules():
        routes.append({
            'endpoint': rule.endpoint,
            'methods': list(rule.methods),
            'rule': rule.rule
        })
    return jsonify(routes)

@app.route("/health", methods=["GET"])
def health():
    """Health check endpoint that tests all routes and dependencies"""
    health_status = {
        "status": "healthy",
        "timestamp": time.time(),
        "checks": {}
    }
    
    overall_healthy = True
    
    # Test database connection
    try:
        db.session.execute('SELECT 1')
        health_status["checks"]["database"] = {"status": "healthy", "message": "Connection successful"}
    except Exception as e:
        health_status["checks"]["database"] = {"status": "unhealthy", "message": str(e)}
        overall_healthy = False
    
    # Test all GET routes
    routes_to_test = [
        {"path": "/", "name": "index"},
        {"path": "/shoppinglist", "name": "shoppinglist"},
        {"path": "/pokemon", "name": "pokemon"},
        {"path": "/dogs", "name": "dogs"},
        {"path": "/dadjokes", "name": "dadjokes"},
        {"path": "/personnotexist", "name": "personnotexist"},
        {"path": "/evilinsult", "name": "evilinsult"}
    ]
    
    with app.test_client() as client:
        for route in routes_to_test:
            try:
                response = client.get(route["path"])
                if response.status_code == 200:
                    health_status["checks"][route["name"]] = {
                        "status": "healthy", 
                        "status_code": response.status_code,
                        "message": "Route accessible"
                    }
                else:
                    health_status["checks"][route["name"]] = {
                        "status": "warning", 
                        "status_code": response.status_code,
                        "message": f"Unexpected status code: {response.status_code}"
                    }
            except Exception as e:
                health_status["checks"][route["name"]] = {
                    "status": "unhealthy", 
                    "message": str(e)
                }
                overall_healthy = False
    
    # Test external API dependencies
    external_apis = [
        {"name": "pokemon_api", "url": "https://pokeapi.co/api/v2/pokemon/pikachu"},
        {"name": "dog_api", "url": "https://dog.ceo/api/breed/labrador/images/random"},
        {"name": "dadjoke_api", "url": "https://icanhazdadjoke.com/", "headers": {"Accept": "application/json"}},
        {"name": "thispersondoesnotexist", "url": "https://thispersondoesnotexist.com"},
        {"name": "evilinsult_api", "url": "https://evilinsult.com/generate_insult.php?lang=en&type=text"}
    ]
    
    for api in external_apis:
        try:
            headers = api.get("headers", {})
            response = requests.get(api["url"], headers=headers, timeout=5)
            if response.status_code == 200:
                health_status["checks"][api["name"]] = {
                    "status": "healthy", 
                    "status_code": response.status_code,
                    "message": "API accessible"
                }
            else:
                health_status["checks"][api["name"]] = {
                    "status": "warning", 
                    "status_code": response.status_code,
                    "message": f"API returned status: {response.status_code}"
                }
        except requests.exceptions.Timeout:
            health_status["checks"][api["name"]] = {
                "status": "warning", 
                "message": "API timeout (>5s)"
            }
        except Exception as e:
            health_status["checks"][api["name"]] = {
                "status": "warning", 
                "message": f"API error: {str(e)}"
            }
    
    # Set overall status
    if overall_healthy:
        health_status["status"] = "healthy"
        return jsonify(health_status), 200
    else:
        health_status["status"] = "unhealthy"
        return jsonify(health_status), 503

@app.route("/", methods=["GET", "POST"])
def index():
    return render_template("index.html")

@app.route("/shoppinglist", methods=["GET", "POST"])
def shoppinglist():
    if request.method == "POST":
        item_name = request.form["item_name"].strip()
        if item_name:
            new_item = ShoppingItem(name=item_name)
            db.session.add(new_item)
            db.session.commit()

    items = ShoppingItem.query.all()
    return render_template("shoppinglist.html", items=items)

@app.route("/shoppinglist/delete/<int:item_id>", methods=["POST"])
def delete_item(item_id):
    item = ShoppingItem.query.get_or_404(item_id)
    db.session.delete(item)
    db.session.commit()
    return redirect("/shoppinglist")


@app.route("/pokemon", methods=["GET", "POST"])
def pokemon():
    pokemon_data = None
    error = None

    if request.method == "POST":
        name = request.form["pokemon_name"].strip().lower()
        url = f"https://pokeapi.co/api/v2/pokemon/{name}"
        response = requests.get(url)

        if response.status_code == 200:
            data = response.json()
            pokemon_data = {
                "name": data["name"].title(),
                "height": data["height"],
                "weight": data["weight"],
                "image_url": data["sprites"]["front_default"],
                "types": [t["type"]["name"].title() for t in data["types"]],
                "abilities": [a["ability"]["name"].title() for a in data["abilities"]],
                "stats": {s["stat"]["name"].title(): s["base_stat"] for s in data["stats"]},
                "moves": [m["move"]["name"].title() for m in data["moves"][:5]]  # show only first 5
            }
        else:
            error = f"Pokémon '{name}' not found."

    return render_template("pokemon.html", pokemon=pokemon_data, error=error)

@app.route("/dogs", methods=["GET", "POST"])
def dogs():
    dog_data = None
    error = None

    if request.method == "POST":
        breed = request.form["dog_breed"].strip().lower()
        url = f"https://dog.ceo/api/breed/{breed}/images/random"
        response = requests.get(url)

        if response.status_code == 200:
            data = response.json()
            dog_data = {
                "breed": breed.title(),
                "image_url": data["message"]
            }
        else:
            error = f"Breed '{breed}' not found."

    return render_template("dogs.html", dog=dog_data, error=error)

@app.route("/dadjokes", methods=["GET", "POST"])
def dadjokes():
    joke = None
    error = None

    if request.method == "POST":
        url = "https://icanhazdadjoke.com/"
        headers = {"Accept": "application/json"}
        response = requests.get(url, headers=headers)

        if response.status_code == 200:
            data = response.json()
            joke = data["joke"]
        else:
            error = "Failed to fetch a dad joke."

    return render_template("dadjokes.html", joke=joke, error=error)

@app.route("/personnotexist", methods=["GET", "POST"])
def personnotexist():
    face_url = None
    if request.method == "POST":
        cache_buster = f"?{int(time.time())}{random.randint(1000,9999)}"
        face_url = "https://thispersondoesnotexist.com" + cache_buster
    return render_template("personnotexist.html", face_url=face_url)

@app.route("/evilinsult", methods=["GET", "POST"])
def evilinsult():
    insult = None
    if request.method == "POST":
        try:
            response = requests.get("https://evilinsult.com/generate_insult.php?lang=en&type=text")
            if response.status_code == 200:
                insult = response.text
            else:
                insult = "Could not fetch an insult. Try again!"
        except Exception as e:
            insult = "Error: " + str(e)
    return render_template("evilinsult.html", insult=insult)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000,debug=True)

