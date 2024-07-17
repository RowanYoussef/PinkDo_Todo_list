# PinkDo(To_Do List App)
The application enables you to organize your tasks and wishes efficiently, keeping track of deadlines with a user-friendly interface. It offers a seamless way to manage your to-do list, ensuring you stay on top of your responsibilities. With intuitive navigation and customizable features, it enhances your productivity and helps you achieve your goals effortlessly.

![task list](https://github.com/user-attachments/assets/4939fd12-2c80-4527-a4df-e2c60628f0a1)
## About the app
- The app is developed using Dart programming language and Flutter framework
- It utilizes SQLite as a local database to store tasks in your device, initialized during app installation and automatically deleted upon app removal
- Shared preferences are used to save the selected mode when the app is closed and restore it when reopened
- design patterns : Singlton patern to ensure that only one instance of the database is used , Observer Patern For notifying all screens when a mode switch occurs in one screen,This pattern allows screens to subscribe to changes 
 
### APP_Features and User Manual
1- add a new task or wish

![Screenshot (2)](https://github.com/user-attachments/assets/336dc57c-0bae-4bf0-879d-3ffcd92e73f2)

2- select deadline for task (optional)


![Screenshot (3)](https://github.com/user-attachments/assets/fedcb6aa-cbf9-4d07-a277-d5c46d655a93)

3- choose icon for a task (optional)


![Screenshot (4)](https://github.com/user-attachments/assets/2eeb785b-1f6f-47e4-9ea8-dda49eb8c6f1)

4- toDo_List screen with a progress indicator to display the percentage of completed tasks


![Screenshot (5)](https://github.com/user-attachments/assets/5373afb3-9ffb-4240-9094-82d99e146bce)

5- remove a specific task or clear all tasks


![Screenshot (6)](https://github.com/user-attachments/assets/3248b7a3-f5ef-442e-8cc0-93ebf1459a85)

6- Wish_List screen

![Screenshot (7)](https://github.com/user-attachments/assets/9ddf56b4-4411-44dd-af8c-c4e1582e6d6b)

7-blue_mode option i think it's preferable to pink 😆



![Screenshot (8)](https://github.com/user-attachments/assets/faac64e9-529b-4554-be17-556f2d2b12c3)

8-task details



![Screenshot (9)](https://github.com/user-attachments/assets/3633780c-c307-481c-bc92-708dc4f3b61d)

#### To run the app
1-install android studio and flutter frame work

2-create an emulator device in android studio

3-clone the repo

4-install packages 

#####
     flutter pub get

5-run the app



