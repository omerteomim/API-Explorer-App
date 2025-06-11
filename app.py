from flask import Flask, request, render_template, jsonify
import requests

app = Flask(__name__)
@app.route("/", methods=["GET", "POST"])
def index():
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

    return render_template("index.html", pokemon=pokemon_data, error=error)
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000,debug=True)

