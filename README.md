# openCX-DroneYourFood Development Report

Welcome to the documentation pages of the _Drone your Food_ of **openCX**!

You can find here detailed about the (sub)product, hereby mentioned as module,
from a high-level vision to low-level implementation decisions, a kind of
Software Development Report (see
[template](https://github.com/softeng-feup/open-cx/blob/master/docs/templates/Development-Report.md)
), organized by discipline (as of RUP):

- Business modeling
  - [Product Vision](#Product-Vision)
  - [Elevator Pitch](#Elevator-Pitch)
- Requirements
  - [Use Case Diagram](#Use-case-diagram)
  - [User stories](#User-stories)
  - [Domain model](#Domain-model)
- Architecture and Design
  - [Logical architecture](#Logical-architecture)
  - [Physical architecture](#Physical-architecture)
  - [Prototype](#Prototype)
- [Implementation](#Implementation)
- [Test](#Test)
- [Configuration and change management](#Configuration-and-change-management)
- [Project management](#Project-management)

So far, contributions are exclusively made by the initial team, but we hope to
open them to the community, in all areas and topics: requirements, technologies,
development, experimentation, testing, etc.

Please contact us!

Thank you!

Made By:

- Ana Barros
- João Martims
- João Costa
- Ricardo Fontão

---

## Product Vision

Deliver food quickly and seamlessly to conference participants.

---

## Elevator Pitch

Conference participants waste a lot of time in lines and changing seats when getting
food. Our company helps them feel more immersed in the conference by quickly
and confortably delivering food and beverages just with a few taps on their phones.
What makes our approach unique is the use of new drone technology to bypass any
obstacle and make deliveries as fast as possible.

---

## Requirements

Our application aims to provide the users with the ability to select products,
place orders and to have them delievered by a flying drone. 

This application requires:
  - An android smartphone with internet connection.
  - A [Tello](https://www.ryzerobotics.com/tello) Drone.
  - A running server which receives the commands and sends them to the drone.

### Use case diagram

<img src="images/use_case_diagram.png" width="450">

### Use cases

#### *Check products database*
- **Actor** - Conference participant. 
- **Description** - Allows the actor to check which products are available for ordering.
- **Preconditions** - The user must be logged in and must click the Products List button.
- **Postconditions** - The available products are displayed to the user.
- **Normal Flow**
  - Actor taps the Products list button.
  - Products are displayed.
- **Alternative Flows and Exceptions**
  - Actor taps the Categories list button.
  - Products categories are displayed.
  - The actor taps the wanted category of products to be displayed.
  - Products of that category are displayed.

#### *Make Order*
- **Actor** - Conference participant.
- **Description** - The actor chooses some products and orders them.
- **Preconditions** - The actor must be logged in.
- **Postconditions** - The order is placed.
- **Normal Flow**
  - The user goes to the products list page.
  - The available products are displayed.
  - The user proceeds to tap the products to add to the cart.
  - The user goes to the cart page.
  - The user taps the checkout button.
  - The payment methods are displayed.
  - The user selects a payment method.
  - The application asks for confirmation.
  - The user agrees to pay for the order.
  - The order is placed.
- **Alternative Flows and Exceptions** 
  - The user selects a payment method.
  - The transaction fails.
  - The user retries.

#### *Change Order*
- **Actor** - Conference participant. 
- **Description** - Allows the user to change an order.
- **Preconditions** - The user must be logged in and must have products added to the cart.
- **Postconditions** - Products and quantities on the user's cart change. 
- **Normal Flow** 
  - The actor goes to the cart page.
  - The actor taps the trash icon next to the unwanted products.
  - The unwanted products are removed from the cart.
- **Alternative Flows and Exceptions**
  - The actor taps the '+' sign next to a product.
  - The quantity of the product to be ordered increases. 
  - The actor taps the '-' sign next to a product.
  - The quantity of the product to be ordered decreases.

#### *Cancel Order*
- **Actor** - Conference participant. 
- **Description** - Allows the actor to cancel an order.
- **Preconditions** - The user must be logged in and must have placed an order.
- **Postconditions** - The order is cancelled.
- **Normal Flow**
  - The user is on the checkout page. 
  - The user taps the button to cancel the order.
  - The order is cancelled. 
- **Alternative Flows and Exceptions**
  - None

#### *Deliever Order*
- **Actor** - Admin. 
- **Description** - The drone brings the order to the selected place.
- **Preconditions** - An order has been placed and has not been delievered already. 
- **Postconditions** - The drone arrives at the selected place with the user's order.
- **Normal Flow** 
  - The admin receives and prepares the order.
  - The admin sends the drone with the order.
  - The drone delievers the order to the user.
  - The admin waits for the drone to return.
- **Alternative Flows and Exceptions**
  - The drone is not able to deliever the order to the user.
  - The drone returns to the admin with the order.

### User stories

#### User story map

![User story map](images/user_story_map.png)

#### User story 1


_As a customer, I want to consult the products available for sale._

- **Value = Must Have**
- **Effort = M**

<img src="mockups/products_mockup.png" width="500">

```gherkin
Feature: Consulting available products.

  Scenario: Available products are present when the user taps the products list button
  Given I am logged in
  And I am in the "home" page
  When I am tap the "products list" button
  Then I expect the available products to be present

  Scenario: Product categories are present when the user taps the category list button
  Given I am logged in
  And I am in the "home" page
  When I tap the "category list" button
  Then I expect the "available products" categories to be present

  Scenario: Products of a certain category are present when I tap the button of that category
  Given I am logged in
  And I am on the "category list" page
  When I tap a "category" button
  Then I expect the available products from that category to be present
```


#### User story 2
_As a customer, I must log in into my account to place orders._
- **Value = Must Have**
- **Effort = M**

<img src="mockups/login_mockup.png" width="700">

```gherkin
 Feature: Log In 
 Scenario: The user inputs his email and password to log in
 Given: I have a registered account in DroneYourFood
 When: I enter my email.
 And: I enter my password
 Then: I should be redirected to the "home" page
```

```gherkin
 Feature: Sign In 
 Scenario: The user inputs his email and password to sign in
 Given I am not logged in
 When I enter an email
 And I enter an password
 Then my account should be created
```

#### User story 3

_As a customer, I want to be able to order food/drinks from the available products._

- **Value = Must Have**
- **Effort = L**

<img src="mockups/shoppingcart_mockup.png" width="400">

```gherkin
 Feature: Add products to cart.
 Scenario: the product is added to the user's cart when it is tapped
 Given I am logged in
 And I am on the "products list" page
 When I tap a "product" card
 Then that product should be added to my cart
 And the text "Added product to cart" should be present
```

#### User story 4

_As a customer, I want to have food delivered to me, so I don't have to get up
from my seat._

- **Value = Should Have**
- **Effort = XL**

<img src="mockups/delivery_mockup.png" width="400">>

```gherkin
 Feature: Receive the order.
 Scenario: the user receives the food after the order has been placed
 Given the order has been placed
 When the order is ready for delivery
 Then the drone brings the food to the selected place
```

#### User story 5

_As a customer, I want to be able to check my profile._

- **Value = Should Have**
- **Effort = S**

<img src="mockups/profile_mockup.png" width="400">

```gherkin
 Feature: Check profile.
 Scenario: User can navigate to his profile page by tapping the profile button
 Given I am logged in
 When I press the profile button
 Then my profile's page is loaded
```

#### User story 6

_As a customer, I want to have multiple payment methods available to me._

- **Value = Won't Have**
- **Effort = XL**

<img src="mockups/payment_mockup.png" width="400">

```gherkin
 Feature: Select payment method.
 Scenario: The user selects a payment method by tapping the desired method 
 Given I have specified my order details
 When I tap a payment method
 Then I can use that method to pay for my order
```

#### User story 7

_As a customer, I want to be able to choose the delivery spot for my orders._

- **Value = Could Have**
- **Effort = M**

<img src="mockups/method_mockup.png" width="400">

```gherkin
 Feature: Select delivery place.
 Scenario: The user selects a place 
 Given I have placed an order
 When I am on the checkout page
 Then I select the order delivery spot
```

#### User story 8

_As a customer, I want to be able to change my order._

- **Value = Could Have**
- **Effort = S**

<img src="mockups/history_mockup.png" width="400">

```gherkin
 Feature: Change order.
 Scenario: The user changes the order after placing one 
 Given I have placed an order
 When I am on the checkout page
 Then I go back to the cart page
```

#### User story 9

_As a customer, I want to be able to cancel my order._

- **Value = Could Have**
- **Effort = S**

<img src="mockups/history_mockup.png" width="400">

```gherkin
 Feature: Cancel order.
 Scenario: The user cancels the order after placing one
 Given I have placed an order.
 When I am on the checkout page
 Then I cancel my order
```

#### User story 10

_As a user, I want to be able to recover my password._

```gherkin
 Feature: Recover password.
 Scenario: My password is updated when I input a new password.
 Given I have pressed the "Recover my password" button
 When I input my new password
 Then I my password is updated
```

#### User story 11

_As a user, I want to change my profile picture._

```gherkin
 Feature: Change profile picture.
 Scenario: The profile picture is updated when user uploads a different one.
 Given I have pressed the "Change my profile picture" button
 When I upload a new picture
 Then my profile picture is updated
```

#### User story 12

_As a user, I want to be able to see my purchase history._

<img src="mockups/history_mockup.png" width="400">

```gherkin
 Feature: Purchase history.
 Scenario: The purchase history is displayed when the user goes to the history page.
 Given I have made purchases in the past
 When I go to the purchases page
 Then I can see my purchase history
```

#### User story 13

_As a user, I want to filter products by category._

<img src="mockups/products_mockup.png" width="500">

```gherkin
 Feature: Filter products by category.
 Scenario: The available products from a certain category are shown to the user.
 Given I am on the "Category List" page
 When I press a category
 Then I can see the available products of that category 
```


#### User story 14 

_As a user, I want to be able to sign out of my account._

<img src="mockups/login_mockup.png" width="700">

```gherkin
 Feature: Sign Out
 Scenario: The user can logout when logged in.
 Given I am logged in
 When I press sign out button
 Then I log out
```

### Domain model

Our app allows for the registration of **users** so that we can store their **orders**.

Each **order** contains **products** which the **user** can choose.

**Orders** are then managed by the **server** that mediates the communication with the delivery drones.

![Domain Model](images/domain_model.png)

---

## Architecture and Design

### Logical architecture

Our application is divided into the following packages: 

* **Products** -> responsible for the logic of the product lists
* **Categories** -> reponsible for the filtering of *products* by categories
* **Shopping** -> responsible for managing the shopping cart of each user
* **Profile** -> responsible for displaying and managing user information
* **Authentication** -> responsible for the authentication of the user

![logical diagram](images/logical_diagram.png)

### Physical architecture

![physical architecure diagram](images/physical_architecture.png)

Regarding the phyical architecure of our project, it is divided in the following parts:

* A **Flutter** app that runs on the attendant *smartphone*
* To store *authentication* and *product* data we use Google's **Firebase**
* A **python** webserver to manage the orders and send commands to the **drone**
* A **Tello drone** to deliver the food to the attendant

Regarding the technologies we'll be using on the development of the application,
we decided to use [Flutter](https://www.flutter.com/) because it speed up the
development process and provides an abstraction to android and iOS systems.
It is also used in [open-cx](https://github.com/open-cx/open-cx) making the app
easier to integrate with, if necessary. We decided to go with Firebase for
storage and authentication application, because it is free, provides all the
functionalities needed and Flutter integrates well with it. The drones will
be controlled using a python server. We chose Python because of our familiarity with the language and due to the *Tello sdk* provides code examples in this language. Finally, we were provided a *Tello drone* by the university.  

### Prototype

At the end of our [first iteration](https://github.com/FEUP-ESOF-2020-21/open-cx-t1g3-pantufas/releases/tag/v0.1),
we have implemented the user story
[As a customer, I want to consult the products available for sale](https://github.com/FEUP-ESOF-2020-21/open-cx-t1g3-pantufas/tree/master#user-story-1).
This gave us some basic understanding of Flutter and serves as a very early
example of what the application will be and what it will look like. In this
iteration we have used a JSON file instead of a Firebase instance to store
the product's data (this will be changed later). The prototype has the basis
of the theme we intend to use. This theme will be improved further.

## Implementation

### [ScrollColumn](droneyourfood/lib/Components/ScrollColumn.dart)

This component was created for pages that have their layout based on a _main_
`Column`. `Columns` can overflow the screen, which is a big problem for smaller
devices. This component wraps a `Column` and gives it a scrollbar when it
would overflow the screen. This way, the user can scroll in order to see all
the information and the overflow is avoided.

### [ShoppingCart](droneyourfood/lib/Shopping/Shopping.dart)

The code works around the user's [`ShoppingCart` instance](droneyourfood/lib/Shopping/Shopping.dart).
This class is a [singleton](https://refactoring.guru/design-patterns/singleton),
which means it can be easily accessed from everywhere on the code, both to
get information (avoiding some requeries/parsing from the Firebase instance)
and inserting new information (the formatting and uploading is handled
internally).  
Since this class holds most of the core information of the application, it is
possible to register yourself as an [observer](https://refactoring.guru/design-patterns/observer)
(by passing a funtion to the `notifyWhenLoaded` method), that will be run when
the ShoppingCart loading process is done. The project uses this in conjunction
with the `setState` method of Flutter's stateful widgets in order to show
loading screens/placeholders while the information is not ready, e.g.: list of
products on the shopping cart (`ShoppingListWidget` class, `getShoppingItems`
method).

### Tests mock injection

There are places (e.g.: profile) where we have used/created an extra class,
so we can inject mocks (using
[Mockito](https://flutter.dev/docs/cookbook/testing/unit/mocking)).
This helps writting better unit tests quickly.

### Interfacing with drones

Unfortunately, the drones we had access to during the development of this
project had no GPS/way-point support. This means the interfacing with
[Tello](https://www.ryzerobotics.com/tello) drones exists, but is not used
in the app's code.

There is a [`DroneCommand`](/droneyourfood/lib/Drone.dart) class that sends
commands to a drone. There is a wrapper to interface with this class in
the [`Tools`](/droneyourfood/lib/Tools.dart) class. This class has a final
field that should contain the **ip address/domain and port** to communicate
with the server.

The [`server`](/droneyourfood/dyf_server.py) is written in python. It responds
to **POST** requests containing commands (in plain text). The server class
contains an instance of the `Tello` class. This class takes care of the lower
level drone interaction, logs every interaction and allows an **admin** user
to send commands directly to the drone thought the standard input (**stdin**).
The main missing feature of this server is the limitation of working with a
single drone. This can be easily improved by having a queue of `Tello` class
instances, each interfacing with a single drone. We didn't take care of this
because, we wouldn't be able to test the feature.

---

## Test

### Test Plan

The features we have decided to test were the ones neither dependent on
the drone or Firebase since these are out of our reach. Data classes and
getters should be ignored for testing, as well. This meant the test plan
should consist of three parts:

- Products Widget
- Categories Widget
- Profile Widget

### Test Case Specification

#### Acceptance Tests

Tested using [flutter_gherkin](https://pub.dev/packages/flutter_gherkin) package.

- [Profile](droneyourfood/test_driver/features/profile.feature)

#### Unit Tests

For each test we check if each widget is being displayed as intended
and if it shows the intended information.

- [Products Widget](droneyourfood/test/product_widget.dart)
- [Category Widget](droneyourfood/test/category_widget.dart)
- [Profile Widget](droneyourfood/test/profile_widget.dart)

---

## Configuration and change management

For the purpose of ESOF, we used a very simple approach, just to manage
feature requests, bug fixes, and improvements, using GitHub issues and
following the [GitHub flow](https://guides.github.com/introduction/flow/).

- [Development branches](https://github.com/FEUP-ESOF-2020-21/open-cx-t1g3-pantufas/network)

---

## Project management

We are using _Github Projects_ to manage our tasks. Use this
[link](https://github.com/FEUP-ESOF-2020-21/open-cx-t1g3-pantufas/projects/1)
to check what we are up to.

---

## Evolution - contributions to open-cx

We did not integrate our application with open-cx.
