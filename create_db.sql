-- ============================================
-- Recipe Finder - MySQL schema & seed data
-- Compatible with XAMPP (MariaDB/MySQL)
-- ============================================

-- 1) Create database
CREATE DATABASE IF NOT EXISTS recipe_finder
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE recipe_finder;

-- 2) Drop existing tables (safe re-run)
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS Recipe;
DROP TABLE IF EXISTS Category;
SET FOREIGN_KEY_CHECKS = 1;

-- 3) Create tables
CREATE TABLE Category (
  Category_ID   INT PRIMARY KEY,
  Category_name VARCHAR(50) NOT NULL UNIQUE,
  Photo_URL     VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Recipe (
  Recipe_ID     INT PRIMARY KEY,
  Title         VARCHAR(120) NOT NULL,
  Ingredients   TEXT NOT NULL,
  Created_at    DATE NOT NULL,
  Instructions  TEXT NOT NULL,
  Category_ID   INT NOT NULL,
  CONSTRAINT fk_recipe_category FOREIGN KEY (Category_ID)
    REFERENCES Category(Category_ID)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  INDEX idx_category (Category_ID),
  INDEX idx_title (Title)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4) Seed Category with photos (served from Flask /static)
INSERT INTO Category (Category_ID, Category_name, Photo_URL) VALUES
(1, 'Indian',  '/static/img/categories/indian.svg'),
(2, 'Italian', '/static/img/categories/italian.svg'),
(3, 'Chinese', '/static/img/categories/chinese.svg'),
(4, 'French',  '/static/img/categories/french.svg'),
(5, 'Drinks',  '/static/img/categories/drinks.svg'),
(6, 'Kabab',   '/static/img/categories/kabab.svg');

-- 5) Seed Recipe (provided by you)
INSERT INTO Recipe (Recipe_ID, Title, Ingredients, Created_at, Instructions, Category_ID) VALUES
-- INDIAN (Category_ID = 1)
(1, 'Butter Chicken', 'Chicken, Butter, Tomato, Cream, Spices', '2025-05-14', 'Marinate chicken with spices, cook in butter, add tomato gravy and cream. Simmer until tender and flavorful.', 1),
(2, 'Paneer Tikka', 'Paneer, Yogurt, Spices, Onion, Capsicum', '2025-07-21', 'Marinate paneer cubes with yogurt and spices. Skewer with onion and capsicum, then grill until golden.', 1),
(3, 'Chole Bhature', 'Chickpeas, Flour, Onion, Tomato, Spices', '2025-02-19', 'Cook chickpeas with onion, tomato, and spices. Serve with deep-fried bhature bread.', 1),
(4, 'Masala Dosa', 'Rice, Urad Dal, Potato, Onion, Curry Leaves', '2025-01-25', 'Prepare dosa batter, spread on hot pan, stuff with spiced potato filling, fold, and serve.', 1),
(5, 'Dal Tadka', 'Lentils, Onion, Tomato, Garlic, Spices', '2025-03-10', 'Cook lentils until soft, then temper with onion, garlic, tomato, and spices.', 1),
(6, 'Aloo Paratha', 'Flour, Potato, Onion, Green Chili, Spices', '2025-06-07', 'Stuff chapati dough with spiced mashed potato, roll out, and cook on a hot pan.', 1),
(7, 'Vegetable Biryani', 'Rice, Carrot, Beans, Peas, Spices, Oil', '2025-04-23', 'Layer cooked rice with sautéed spiced vegetables. Steam until flavors blend.', 1),
(8, 'Palak Paneer', 'Spinach, Paneer, Onion, Garlic, Spices', '2025-08-03', 'Puree spinach, cook with spices, and simmer paneer cubes in the gravy.', 1),
(9, 'Rajma Chawal', 'Kidney Beans, Rice, Onion, Tomato, Spices', '2025-07-14', 'Cook kidney beans with onion, tomato, and spices. Serve with steamed rice.', 1),
(10, 'Samosa', 'Flour, Potato, Peas, Onion, Spices, Oil', '2025-02-07', 'Stuff dough with potato-pea filling, fold into triangles, and deep fry.', 1),

-- ITALIAN (Category_ID = 2)
(11, 'Margherita Pizza', 'Pizza Dough, Tomato Sauce, Mozzarella, Basil', '2025-02-10', 'Spread tomato sauce on dough, top with mozzarella and basil. Bake until crust is crisp.', 2),
(12, 'Spaghetti Carbonara', 'Spaghetti, Egg, Parmesan, Bacon, Pepper', '2025-08-12', 'Cook spaghetti, toss with whisked egg, parmesan, and crispy bacon.', 2),
(13, 'Lasagna', 'Pasta Sheets, Minced Meat, Tomato Sauce, Cheese', '2025-04-15', 'Layer pasta with sauce and cheese, then bake until golden.', 2),
(14, 'Pesto Pasta', 'Pasta, Basil, Garlic, Pine Nuts, Olive Oil, Cheese', '2025-03-19', 'Blend pesto ingredients and toss with hot pasta.', 2),
(15, 'Minestrone Soup', 'Pasta, Beans, Carrot, Tomato, Onion, Celery', '2025-06-25', 'Boil vegetables and pasta in broth until tender.', 2),
(16, 'Risotto', 'Arborio Rice, Onion, Stock, Butter, Parmesan', '2025-07-02', 'Cook rice slowly with stock, stir until creamy, add parmesan.', 2),
(17, 'Bruschetta', 'Bread, Tomato, Basil, Olive Oil, Garlic', '2025-01-09', 'Toast bread, rub garlic, and top with tomato-basil mixture.', 2),
(18, 'Fettuccine Alfredo', 'Fettuccine, Cream, Parmesan, Butter', '2025-08-05', 'Cook pasta, toss with butter, cream, and parmesan.', 2),
(19, 'Gnocchi', 'Potato, Flour, Egg, Salt', '2025-02-28', 'Shape dough into small dumplings, boil, and toss with sauce.', 2),
(20, 'Caprese Salad', 'Tomato, Mozzarella, Basil, Olive Oil', '2025-04-22', 'Slice tomato and mozzarella, layer with basil, drizzle oil.', 2),

-- CHINESE (Category_ID = 3)
(21, 'Fried Rice', 'Rice, Egg, Soy Sauce, Carrot, Peas, Oil', '2025-04-03', 'Cook rice, stir-fry with vegetables, egg, and soy sauce.', 3),
(22, 'Sweet and Sour Chicken', 'Chicken, Pineapple, Bell Peppers, Vinegar, Soy Sauce', '2025-03-17', 'Fry chicken, add sauce with pineapple and peppers.', 3),
(23, 'Chow Mein', 'Noodles, Carrot, Cabbage, Soy Sauce, Oil', '2025-02-02', 'Boil noodles, stir-fry with vegetables and soy sauce.', 3),
(24, 'Hot and Sour Soup', 'Mushroom, Tofu, Vinegar, Soy Sauce, Pepper', '2025-05-15', 'Simmer ingredients in broth until flavorful.', 3),
(25, 'Kung Pao Chicken', 'Chicken, Peanuts, Chili, Soy Sauce, Garlic', '2025-06-27', 'Fry chicken with chili and garlic, add sauce and peanuts.', 3),
(26, 'Spring Rolls', 'Flour Wrappers, Cabbage, Carrot, Oil, Soy Sauce', '2025-07-10', 'Fill wrappers with vegetables, roll tightly, and deep fry.', 3),
(27, 'Mapo Tofu', 'Tofu, Chili Bean Paste, Garlic, Oil', '2025-08-08', 'Cook tofu in spicy chili bean sauce with garlic.', 3),
(28, 'Dim Sum Dumplings', 'Flour, Pork, Shrimp, Cabbage, Ginger', '2025-01-29', 'Fill dough with mixture, steam until tender.', 3),
(29, 'Sesame Chicken', 'Chicken, Sesame Seeds, Soy Sauce, Honey', '2025-03-28', 'Coat chicken in sauce, sprinkle with sesame.', 3),
(30, 'Egg Foo Young', 'Egg, Bean Sprouts, Onion, Soy Sauce', '2025-06-13', 'Beat eggs with vegetables, fry into omelets, add sauce.', 3),

-- FRENCH (Category_ID = 4)
(31, 'Croissant', 'Flour, Butter, Yeast, Sugar, Milk', '2025-06-29', 'Make laminated dough, shape, and bake.', 4),
(32, 'French Onion Soup', 'Onion, Butter, Beef Broth, Bread, Cheese', '2025-08-01', 'Caramelize onions, simmer in broth, top with bread and cheese.', 4),
(33, 'Quiche Lorraine', 'Egg, Cream, Cheese, Bacon, Pastry', '2025-05-06', 'Fill pastry with egg mixture and bake.', 4),
(34, 'Ratatouille', 'Zucchini, Eggplant, Tomato, Onion, Pepper', '2025-07-01', 'Layer vegetables with sauce, bake until tender.', 4),
(35, 'Coq au Vin', 'Chicken, Red Wine, Onion, Garlic, Mushroom', '2025-04-26', 'Simmer chicken in red wine with vegetables.', 4),
(36, 'Beef Bourguignon', 'Beef, Red Wine, Onion, Carrot, Garlic', '2025-03-12', 'Slow cook beef in wine with vegetables.', 4),
(37, 'Crème Brûlée', 'Cream, Sugar, Egg Yolk, Vanilla', '2025-06-05', 'Bake custard, top with caramelized sugar.', 4),
(38, 'Madeleines', 'Flour, Egg, Sugar, Butter, Lemon', '2025-01-31', 'Make batter, bake in shell molds.', 4),
(39, 'Nicoise Salad', 'Tuna, Egg, Potato, Tomato, Olive', '2025-02-16', 'Assemble ingredients on plate, drizzle dressing.', 4),
(40, 'Baguette', 'Flour, Water, Yeast, Salt', '2025-07-16', 'Knead dough, shape, and bake until crusty.', 4),

-- DRINKS (Category_ID = 5)
(41, 'Mojito', 'Mint, Lime, Sugar, Soda, Rum, Ice', '2025-01-26', 'Muddle mint and lime, add rum, ice, soda.', 5),
(42, 'Mango Lassi', 'Mango, Yogurt, Sugar, Milk, Cardamom', '2025-07-04', 'Blend mango pulp with yogurt and sugar.', 5),
(43, 'Cold Coffee', 'Milk, Coffee, Sugar, Ice', '2025-05-09', 'Blend milk, coffee, sugar, and ice.', 5),
(44, 'Lemonade', 'Lemon, Sugar, Water, Ice', '2025-06-21', 'Mix lemon juice with sugar and water.', 5),
(45, 'Iced Tea', 'Tea, Sugar, Lemon, Ice', '2025-08-18', 'Brew tea, chill, serve with lemon and ice.', 5),
(46, 'Hot Chocolate', 'Milk, Cocoa, Sugar, Cream', '2025-02-13', 'Heat milk with cocoa and sugar, top with cream.', 5),
(47, 'Strawberry Smoothie', 'Strawberry, Yogurt, Milk, Sugar', '2025-03-08', 'Blend strawberries with yogurt and milk.', 5),
(48, 'Orange Juice', 'Orange, Sugar, Water', '2025-04-17', 'Squeeze orange juice, strain, chill.', 5),
(49, 'Banana Milkshake', 'Banana, Milk, Sugar, Ice', '2025-07-19', 'Blend bananas with milk and ice.', 5),
(50, 'Pina Colada', 'Pineapple Juice, Coconut Cream, Rum, Ice', '2025-05-20', 'Blend pineapple juice with coconut cream and rum.', 5),

-- KABAB (Category_ID = 6)
(51, 'Seekh Kabab', 'Minced Meat, Onion, Chili, Spices, Oil', '2025-01-11', 'Mix minced meat with spices, shape onto skewers, grill.', 6),
(52, 'Shami Kabab', 'Minced Meat, Chana Dal, Onion, Spices', '2025-02-22', 'Cook minced meat with dal, grind, shape into patties, and fry.', 6),
(53, 'Galouti Kabab', 'Minced Meat, Spices, Gram Flour, Oil', '2025-03-14', 'Prepare spiced meat mixture, shallow fry until soft.', 6),
(54, 'Chapli Kabab', 'Minced Meat, Onion, Tomato, Spices', '2025-04-19', 'Shape meat mixture into flat patties and shallow fry.', 6),
(55, 'Hara Bhara Kabab', 'Spinach, Peas, Potato, Spices, Bread Crumbs', '2025-05-16', 'Make a mixture, shape into patties, and shallow fry.', 6),
(56, 'Boti Kabab', 'Mutton, Yogurt, Spices, Onion', '2025-06-08', 'Marinate mutton cubes in yogurt and spices, then grill.', 6),
(57, 'Chicken Malai Kabab', 'Chicken, Cream, Yogurt, Spices', '2025-07-22', 'Marinate chicken with cream and yogurt, grill until tender.', 6),
(58, 'Tandoori Kabab', 'Chicken, Yogurt, Chili, Spices', '2025-08-06', 'Marinate chicken pieces, skewer, and cook in tandoor.', 6),
(59, 'Reshmi Kabab', 'Chicken, Cream, Cashew, Yogurt, Spices', '2025-02-05', 'Marinate chicken with rich creamy spices, grill.', 6),
(60, 'Mutton Seekh Kabab', 'Mutton Mince, Onion, Chili, Garlic, Spices', '2025-03-29', 'Shape mutton mince on skewers and grill.', 6);
