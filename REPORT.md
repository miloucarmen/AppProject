## RoomiesApp

## OverView of the app
roommies app helps roommates keeping track of who payed what, always knowing what is the inventory and what needs to be bought. They can also share a calendar and events.


## Technical design
### Highlevel overview
#### Login/Sign in
when the app is opened the sign up scene will be shown you can either log in or sign in. When succesfully signed in or logged in the home screen will appear.
#### Homescreen
Here you have 5 options you can view tap the calendar, bills, inventory, shopping list or wipe to the right to get the settings scene.
#### Calendar
When the calendar is tapped you will get a calendar and a table view with events on the current date. To see other data from other days the date you want to view has to be tapped. 
To navigate through the months previous and next can be pressed. 
The last to buttons are cancel, which returns you to homescreen and +. The + button will send you to the add event scene
#### Add Event
In the add event scene you can make a new event for your roommates to see. You do this by filling in a description and choosing a date and time. After this you press save.
#### Bills
The Bills scene gives an overview of who payed what and for who. When you press the headers the rows will become visable or will dissappear. Just like with who payed what you can see how much you are owed or owe to people. 
When you press a row from your own column (the column with your username), you can edit the cost or with you you split it.
when you press + you will be redirected to the Add Bill Scene
#### Add Bill Scene
The add bills scene gives you the possibility to add a new bill by adding a description of the cost made and add an amount. by default all the roommate switches are on the can be changed accordingly.
#### Shopping List
In the shopping list scene there is the option to either add edit or say you bought an item. add and edit will redirect you to the add Shopping List item scene while Bought! will remove the item from the shopping list and add it to the inventory
#### Add To Shopping List
The add to shopping list scene asks for a item and an amount and saves it to your shopping List.
#### Inventory
In the shopping list scene there is the option to either add edit or remove an item. 
#### Add To Inventory
The add to inventory scene requires an amount and item just like add to shopping List
#### Settings scene
Here you can see your current roommates. Your send friend requests and retract them by tapping the minus button. Or friendRequests send to you and you can accept them.
When you click the add button in the bottom right corner you will be redirected to the add roommate scene
#### Add Roommate Scene
Here you will find a list of all the users of the app and you can press the row of who you want to add to your roommates.
If you were the one to send the request you can retract the friend request, by pressing on the row again.

### Lowlevel overview

#### Login/Sign in
The login is from class: ViewController screen uses selector to change between register en login. It uses firebase authenticater to create new users and check current users login.
#### Homescreen
The home screen is from class viewController one of the two ViewControllers that is nested in a pageViewController. The pageViewController makes it possible to swipe between homescreen en settingscreen. The homescreen is connected to the other views via segue's.
#### PageViewController
the classes used in the PageViewController are: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate. Its only functions are to make sure you can swipe between settings and homescreen
#### Calendar

#### Add Event
#### Bills
#### Add Bill Scene
#### Shopping List
#### Add To Shopping List
#### Inventory
#### Add To Inventory
#### Settings scene
#### Add Roommate Scene

