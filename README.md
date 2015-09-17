# Description
For this app, I built a ruby command line app that accepts valid HTTP requests and returns an appropriate response while interacting with a Users table in a database.

## To run
Enter the root directory and run the command `ruby bin/run`

When in the app, the user must enter the appropriate url format with the correct action and HTTP protocol to receive the appropriate data.

### View all users
In order to view all users from the database, enter a url in the format: `GET http://localhost:3000/users HTTP/1.1`

### View individual records
In order to view an individual user from the database, enter a url in the format: `GET http://localhost:3000/users/1 HTTP/1.1`

In case a record was requested that didn't exist, such as entering the url: `GET http://localhost:3000/users/9999999 HTTP/1.1` the user will see an error message.

### View certain users with queries
In order to view specific users whose name starts with a certain character from the database, enter a url in the format: `GET http://localhost:3000/users?first_name=s`

### View certain users with queries
In order to view a certain limit of users with an offset from the database, the user must enter a url in the following format: `GET http://localhost:3000/users?limit=10&offset=10`

### Delete a specific user
In order to delete a certain user from the database, the user must enter a url in the following format: `DELETE http://localhost:3000/users/1`