# Code Overview for the cart app

**Architecture Used:** BLOC
**Layers:**
 - presentation
 - data
 - business logic

## Presentation Layer

This layers consist the widget which are directly visible to the user. The UI/Frontend part is there. It contains two pages.

 1. Home page
 2. Cart page

### Home page:

A GridView builder is used with fixed cross axis size 2 to show the item cards.
Image.network is used to show a image from the internet. and add/remove card is shown as per the `cart state` of the item. 

An animation is used to show flying item to the cart button at the app bar.
To show that animation, A overlay entry is used with a child of the item's image.
The overlay entry is placed at the `add button` offset, which we got by using `var box = context.findRenderObject as RenderBox` and `box.localToGlobal` to get the global position of the add button widget (startOffset). After that tween animation from startOffset to the Offset(screen width, 0) is used. Thus getting the complete animation.

### Cart page:

Listview builder with cards is used to display the list of items in cart. A another card is used to show the total price and item count.


## Data Layer

Data layer consists:

 1. Models
 2. Data providers
 3. Repository

For getting the products from a fake api and fetching it we're using the data layer. Here:

### 1. Models:

We have a model as product_model, which have all the information about an item/product (item name, image, price, etc). It is the blueprint of the data.


### 2. Data providers

Here we have data provider as product_provider, which use http library and request a json file from `https://fakestoreapi.com/products` and return it if not error is occurred.

### 3. Repository

Here we have product_repository, which use the data provider's data and fetch/convert into usable format, using the model (product_model in this case) and return it.


## Business Logic

Here the state management, helper functions, controller consist. In this project we have one bloc and one cubit module. 

1. for cart state we're using bloc
2. for product state we're using cubit (as it is simpler than cart state)

below are the files associated with a bloc or cubit instance

**<>_bloc:** It contains, on which event what to do and to which state it should be moved

**<>_state:** It defines the different state of the cart module

**<>_event:** It contains the different event, that can be occurred or done by the user or recursively by the app.

### 1. Cart state:

here we have cart_bloc, cart_event, cart_state.

On app is started we're moving the state of cart state from initial to loaded.
On a item is added or removed, we're adding and removing respectively from the loaded state (while doing showing loading state). after the adding is done again shifted to loaded from loading. loaded state as attribute as items, added/remove item, total price etc.

### 2. Product state:

here we have product_cubit, product_state.

when app is started `product_requested` function from product_cubit is call which get the data from product_repository. If there is no data the state is changed to `empty` else `loaded`. The `loaded` state has a attribute products which is a list< Product >, which can be displayed by the presentation layer.

