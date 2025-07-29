from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class ShoppingItem(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
