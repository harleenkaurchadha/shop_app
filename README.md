# About app

In this we are going to make a shopping app with firebase as a server.This app has a main screen which contains a list of all the products in gridview with a favourite and add to cart button. we can favourite the products we want which will be displayed in another screen by clicking on 3 vertical dots and selecting only favourites. We have also added a functionality in which we can add our own product which will be available to shop for by users. To do so we need to click on app drawer and select manage products, by which we will be directed to a screen where we can add a product by clicking on add button and then giving the neccessary details like title, price, description and the link for image to be displayed and save this information. After doing so our product will be added on this manage product screen and the main product overview screen to shop. In manage product window we can edit or delete our products. You can shop for the products by clicking on shopping cart button next to the product image by which our product will be added to cart and cart number updates in appbar. After adding all the products to be purchased you can order them by clicking on shopping cart button in appbar which will direct us to ascreen where our total amount will be displayed and we can then click order now to order. On pressing order now our cart will be emptied and we can then prepare for our next order. To have a look at your orders go to the app drawer and click on orders you will get all the orders placed by you with their date and time of placing order, and you can get the detail of you ordered products by clicking on the downward arrow button next to your order. In this app we will be using firebase's realtime database to serve our database needs to store all the products, orders, user favourite products and users info.

## Insights of app


![output](https://user-images.githubusercontent.com/23056679/111500673-40e58980-876a-11eb-94ce-3764762f7248.gif)

### Firebase snapshots

<img width="700" alt="Screen Shot 2021-03-17 at 5 25 02 PM" src="https://user-images.githubusercontent.com/23056679/111495962-dd595d00-8765-11eb-92b1-6a8610d909f6.png">  &nbsp;   <img width="700" alt="Screen Shot 2021-03-17 at 5 25 13 PM" src="https://user-images.githubusercontent.com/23056679/111496019-e9451f00-8765-11eb-8c67-7ca234c79aa4.png">   &nbsp;    <img width="700" alt="Screen Shot 2021-03-17 at 5 25 20 PM" src="https://user-images.githubusercontent.com/23056679/111496090-fcf08580-8765-11eb-965e-c3aa0c765e9c.png">


## How to use

### step 1:

Download or clone this repo by using the following link:

[<u>git@github.com:harleenkaurchadha/shop_app.git</u>](https://git@github.com:harleenkaurchadha/shop_app.git)

### step 2:

Go to the project root and execute the following command to get all dependencies packages:
```bash
flutter pub get
```

### step 3:

Go to firebase console select your project and in authentication section, go to sign in method and enable email-password sign in.

### step 4:

Go to Realtime database and in rules section do the following:

<img width="700" alt="Screen Shot 2021-03-17 at 12 21 56 AM" src="https://user-images.githubusercontent.com/23056679/111488698-7d5fb800-875f-11eb-9dfc-5d0c341dd40e.png">

### step 5:

In data section of realtime database copy the url for your database and accordingly insert in code wherever fetching from database is required.
