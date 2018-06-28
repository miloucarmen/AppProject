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
#### Bills Table ViewController
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
##### Calendar class
The calendar view is a ViewController class. The changing calendar is made possible by a collection view so in addition to the UIViewControllerClass it also has: UICollectionViewDelegate, UICollectionViewDataSource, CalendarCellDelegate class elements. Its biggest functions are startDatePositions(), nextMonth() and PreviousMonth(). The first function calculates the number of white space you see when a month doesnt start on monday. The nextMonth/previous function is called when next/previous button is pressed it makes sure when needed the year is changed and keeps track of whether it is a leap year. The last big function is the didPressButton() function which is of class calendarCellDelegate which retrives information from firebase if requested by a tap on a specific date in the calendar.
##### EventTableViewController
The event table is a Table view nested in the calendar view. It displays a the events on a date
##### CalendarVars
Here are a view variables for the calendar stored
##### CalendarCollectionViewCell
Hold the information whats inside one of the collectionview cells of the calendar. Also assigns a delegate for the function when the cell is pressed.
#### Add Event
Add event is a static table with three sections. It has two UIDatePickers. Its most important function is the safe function which safe the event to firebase
#### Bills Table ViewController
It's class is a UITableViewController. It has a dynamic number of sections and row, which is programmatically made. Important functions WieBetaaltWat which calculates if you are owed or not. It does this by iteration through all bills from every roommate to check if you paid or someonelse paid something for you. It then post this amount in the header. The OpenClose function is also important is uses tableview.insert en .delete to make the rows appear or disappear. The prepare functions make sure there is interaction with add Bill Scene by sending the current information to the controller when show details is asked this way you dont have to retype the bill information. 
##### BillCell
BillCell is of type UITableViewCell it contains the information for the cells of the rows ot Bill Table. 
#### Add Bill Scene
The add to Bill Scene has a lot of properties. The classes of this scene are UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource. It has a static table with 3 section in section 1 you can find a textField, section 2 a UIPicker and in section 3 there is a nested table view with a dynamic table. Important functions in this scene are prepare which saves data to firebase and tableView functions. Besides the AddToBills class there is also a Innertablecontroller class, which handels the table in the 3 section. It's from class NSObject, UITableViewDelegate, UITableViewDataSource, InsideTableCellDelegate. The switchEnabled function is important because it keeps track of for who you paid, which is important for the calculation in the Bills TableViewController. 
##### InsideTableCell
The InsideTableCell is the cell of the InnerTableController. It has a delegate for the function that is used in addBillScene
#### Shopping List
ShoppingList class is a UITableViewController and contains ShoppingListCellDelegate. In viewdidload it loads information from firebase from all roommates. An important function is didPressbutton() which is the delegate method from the shoppingList Cell. It loads the item to firebase under inventory. So it will appear on the inventory list when bought. The last important function is the show details prepare for segue. With routes information to the Add To Shopping List Scene
##### ShoppingListCell
The custom Cell contains a delegate methode.
#### Add To Shopping List
Has UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource. Just like AddBills it has a textField and UIPicker. a function makes sure you can't save the item unless a text and amount has been added. When save is pressed the item is save to firebase.
#### Inventory
Inventory has a lot of the same properties as shoppingList it it a tableView as well. It only doesnt have a button in the tableView cell because its already in inventory. 
#### Add To Inventory
Add to inventor is the same as Add To Shopping List scene. Only it saves to firebase under a different name. 
#### Settings scene
The settings Scene is a Viewcontroller that is also nested in the pageviewController. it has classes: UIViewController, UITableViewDataSource, UITableViewDelegate, SettingsCellDelegate. viewDidLoad() loads information from firebase. An important function is viewWillLayoutSubviews() which creates a button overlaying the tableView. This button redirects to AddRoommate Scene through a segue. The function didPressButton is the SettingCellDelegate function, it will depending on which section the button is pressed add a person to roommates or retract an outstanding request you send.
##### SettingsCell
Has delegate to the function with is responsable for adding roommates and retracting pending requests
#### Add Roommate Scene
Add Roommate Scene is a UITableViewController it most important functions are viewDidLoad() in which all current users off the app are collected from firebase. And all the information regarding who are already you roommates or you have a request from or send to. With this information it updates the table in such a manner that you can't send double invites to a person. The other is didSelectRow function when a row is selected a friendrequest is send to a person. In this function you can see that the autoIDkeys is used twice,for you and the person you send the request to, this way its possible to retract a friend request. 
##### Add RoommateCell
This cell is very simple just a button and a label

## Challenges of this app
### Challenges in general
I noticed that I learned a lot more about how xcode and the language works through doing it from scratch. The big challenges where with the structure of the firebase data. I ended up making a whole different structure halfway through the project with cause loss of time because I had to go back and change it in the old ViewControllers. Another big challenge was with the addToBill scene. The table view nested in a table view caused a lot of weird errors, which I could not solve. I solved this with some help. 
### Changes made
I was originally going to use google calendars, which I ended up not using.
### Was it a good thing
For the calendar I was originally going to use google calendars. Due to a not for apple availble open api key I would have had to use a close api key. This would have meant that I needed an extra login screen and you could only use the app with google acounts. It would also have meant that people would have to login with google and firebase because this cant be connected. So it think it was a good decision to not use it. I like the solution I have now. 


