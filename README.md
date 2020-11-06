# openCX-DroneYourFood Development Report

Welcome to the documentation pages of the _your (sub)product name_ of **openCX**!

You can find here detailed about the (sub)product, hereby mentioned as module, from a high-level vision to low-level implementation decisions, a kind of Software Development Report (see [template](https://github.com/softeng-feup/open-cx/blob/master/docs/templates/Development-Report.md)), organized by discipline (as of RUP):

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
food. Our company helps them feel more immersed in the various talks by quickly
and confortably delivering food and beverages, thus reducing time spent in lines
and changing seats. What makes our approach unique is the use of new drone technology
to bypass any obstacle and make deliveries as fast as possible.

---

## Requirements

In this section, you should describe all kinds of requirements for your module: functional and non-functional requirements.

Start by contextualizing your module, describing the main concepts, terms, roles, scope and boundaries of the application domain addressed by the project.

### Use case diagram

![interface mockup](images/use_case_diagram.png)

### User stories

**Must have**:

- _As a customer, I want to consult the products available for sale_. **Value = XL**. **Effort = M**.

```gherkin
Feature: Consulting available products.
Given: I am a DroneYourFood user.
And: I am logged in.
When: I am on the products page.
Then: I see the available products.
```

![interface mockup](mockups/interface_mockup.png)

- _As a customer, I must log in into my account to place orders_.

```gherkin
 Feature: Login functionality.
 Given: I have a registered account in DroneYourFood.
 When: I enter username as username.
 And: I enter the password as the password
 Then: I should be redirected to the products page of DroneYourFood.
```

- _As a customer, I want to be able to order food/drinks from the available products_.

```gherkin
 Feature: Select orders.
 Given: I am logged in.
 When: I am on the products page.
 Then: Selected products must be added to cart.
```

**Should have**:

- _As a customer, I want to have food delivered to me, so I don't have to get up
  from my seat_.

```gherkin
 Feature: Deliver the order.
 Given: The order has been placed.
 When: The order is ready for delivery.
 Then: The drone brings the food to the selected place.
```

- _As a customer, I want to have multiple payment methods available to me_.

```gherkin
 Feature: Select payment method.
 Given: I have specified my order details.
 When: I am on the checkout page.
 Then: I can select the payment method.
 And: I can finish paying for my order.
```

**Could have**:

- _As a customer, I want to be able to choose the delivery spot for my orders_.

```gherkin
 Feature: Select delivery place.
 Given: I have finished selecting all the products I want to order.
 When: I am on the checkout page.
 Then: I register the order delivery spot.
```

- _As a customer, I want to be able to change my order_.

```gherkin
 Feature: Change order.
 Given: I have placed an order.
 When: I am on the checkout page.
 Then: I go back to the objects page.
```

- _As a customer, I want to be able to cancel my order_.

```gherkin
 Feature: Cancel order.
 Given: I have placed an order.
 When: I am on the checkout page.
 Then: I cancel my order.
```

---

## Project management

We are using _Github Projects_ to manage our tasks. Use this
[link](https://github.com/FEUP-ESOF-2020-21/open-cx-t1g3-pantufas/projects/1)
to check what we are up to.
