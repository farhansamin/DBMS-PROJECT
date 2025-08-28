from flask import Flask, render_template, request, abort, redirect, url_for, flash, session
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash
import os
from werkzeug.utils import secure_filename


app = Flask(__name__)
app.secret_key = "supersecretkey"  # needed for session + flash

# Use env var DATABASE_URI if set; else default to XAMPP-style MySQL root/no password
# Example: mysql+pymysql://root@127.0.0.1/recipe_finder?charset=utf8mb4
db_uri = os.getenv("DATABASE_URI", "mysql+pymysql://root@127.0.0.1/recipe_finder?charset=utf8mb4")
app.config["SQLALCHEMY_DATABASE_URI"] = db_uri
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db = SQLAlchemy(app)

class Category(db.Model):
    __tablename__ = "Category"
    Category_ID = db.Column(db.Integer, primary_key=True)
    Category_name = db.Column(db.String(50), nullable=False, unique=True)
    Photo_URL = db.Column(db.String(255), nullable=False)
    recipes = db.relationship("Recipe", backref="category", lazy=True)

class Recipe(db.Model):
    __tablename__ = "Recipe"
    Recipe_ID = db.Column(db.Integer, primary_key=True)
    Title = db.Column(db.String(120), nullable=False)
    Ingredients = db.Column(db.Text, nullable=False)
    Created_at = db.Column(db.Date, nullable=False)
    Instructions = db.Column(db.Text, nullable=False)
    Category_ID = db.Column(db.Integer, db.ForeignKey("Category.Category_ID"), nullable=False)


class LoginPage(db.Model):
    __tablename__ = "loginpage"   # your actual table name
    User_ID = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(50), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(255), nullable=False)


class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(50), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(128), nullable=False)



class UserProfile(db.Model):
    __tablename__ = "userprofile"

    profile_id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey("loginpage.User_ID"), unique=True, nullable=False)
    bio = db.Column(db.Text, default="")
    profile_pic = db.Column(db.String(255), default="default.png")
    cooking_level = db.Column(db.String(50), default="Beginner")
    

    # Link to LoginPage 
    user = db.relationship("LoginPage", backref=db.backref("profile", uselist=False))

@app.route('/profile', methods=['GET', 'POST'])
def user_profile():
    if 'user_id' not in session:
        flash("Please log in to view your profile.", "danger")
        return redirect(url_for('login'))

    # Fetch user and profile
    user = LoginPage.query.get_or_404(session['user_id'])
    profile = UserProfile.query.filter_by(user_id=session['user_id']).first()

    # Create profile if it doesn't exist
    if not profile:
        profile = UserProfile(user_id=session['user_id'])
        db.session.add(profile)
        db.session.commit()

    # Handle POST (form submission)
    if request.method == 'POST':
        profile.bio = request.form.get('bio', '')
        profile.cooking_level = request.form.get('cooking_level', 'Beginner')

        # Handle profile picture upload
        if 'profile_pic' in request.files:
            file = request.files['profile_pic']
            if file and file.filename != '':
                filename = secure_filename(file.filename)
                file.save(os.path.join('static/profile_pics', filename))
                profile.profile_pic = filename

        db.session.commit()
        flash("Profile updated successfully!", "success")
        return redirect(url_for('user_profile'))

    return render_template('profile.html', user=user, profile=profile)


@app.route("/edit_profile", methods=["GET", "POST"])
def edit_profile():
    if "user_id" not in session:
        flash("Please log in to edit your profile.", "error")
        return redirect(url_for("login"))

    profile = UserProfile.query.filter_by(user_id=session["user_id"]).first()

    # If profile doesn't exist, create one
    if not profile:
        profile = UserProfile(user_id=session["user_id"])
        db.session.add(profile)
        db.session.commit()

    if request.method == "POST":
        # Save bio and cooking level
        profile.bio = request.form.get("bio", "")
        profile.cooking_level = request.form.get("cooking_level", "Beginner")

        # Handle profile picture upload
        if "profile_pic" in request.files:
            file = request.files["profile_pic"]
            if file and file.filename != "":
                filename = secure_filename(file.filename)
                filepath = os.path.join("static/profile_pics", filename)
                file.save(filepath)
                profile.profile_pic = filename  # Save only filename in DB

        db.session.commit()
        flash("Profile updated successfully!", "success")
        return redirect(url_for("user_profile", user_id=session["user_id"]))

    return render_template("edit_profile.html", profile=profile)


@app.route("/")
def index():
    user_profile = None
    # Check if user is logged in
    if "user_id" in session:
        user_profile = UserProfile.query.filter_by(user_id=session["user_id"]).first()

    q = request.args.get("q", "").strip()
    if q:
        # basic search over Title and Ingredients
        like = f"%{q}%"
        results = Recipe.query.filter(
            db.or_(Recipe.Title.ilike(like), Recipe.Ingredients.ilike(like))
        ).order_by(Recipe.Title.asc()).all()
        return render_template("search.html", q=q, results=results, profile=user_profile)

    categories = Category.query.order_by(Category.Category_name.asc()).all()
    return render_template("index.html", categories=categories, profile=user_profile)


@app.route("/category/<int:category_id>")
def category_view(category_id):
    cat = Category.query.get_or_404(category_id)
    recipes = Recipe.query.filter_by(Category_ID=category_id).order_by(Recipe.Title.asc()).all()
    return render_template("category.html", category=cat, recipes=recipes)


@app.route("/recipe/<int:recipe_id>")
def recipe_view(recipe_id):
    r = Recipe.query.get_or_404(recipe_id)
    # Split the comma-separated Ingredients into a neat list
    ingredients = [i.strip() for i in r.Ingredients.split(",") if i.strip()]
    return render_template("recipe.html", r=r, ingredients=ingredients)


# ---- LOGIN / LOGOUT / SIGNUP ----
@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        email = request.form["email"]
        password = request.form["password"]
        user = LoginPage.query.filter_by(email=email).first()
        if user and check_password_hash(user.password_hash, password):
            session["user_id"] = user.User_ID
            flash("Login successful!", "success")
            return redirect(url_for("index"))
        else:
            flash("Invalid email or password", "danger")
    return render_template("login.html")


@app.route("/logout")
def logout():
    session.pop("user_id", None)
    flash("You have been logged out.", "info")
    return redirect(url_for("login"))


@app.route("/signup", methods=["GET", "POST"])
def signup():
    if request.method == "POST":
        username = request.form["username"]
        email = request.form["email"]
        password = request.form["password"]
        confirm = request.form["confirm_password"]

        if password != confirm:
            flash("Passwords do not match!", "danger")
            return redirect(url_for("signup"))

        # check if user exists
        if LoginPage.query.filter((LoginPage.username == username) | (LoginPage.email == email)).first():
            flash("Username or email already exists!", "danger")
            return redirect(url_for("signup"))

        hashed_pw = generate_password_hash(password)
        new_user = LoginPage(username=username, email=email, password_hash=hashed_pw)
        db.session.add(new_user)
        db.session.commit()

        flash("Account created! You can now log in.", "success")
        return redirect(url_for("login"))

    return render_template("signup.html")


if __name__ == "__main__":
    # Run the app
    app.run(debug=True)
