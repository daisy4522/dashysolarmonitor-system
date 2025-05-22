const express = require("express");
const path = require("path");
const mysql = require("mysql");
const session = require("express-session");
const dbConnection = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",

  database: "dashysolaymonitor_db",
});

const app = express();

// middleware
app.use(express.static(path.join(__dirname, "public"))); // path -- nested routs /booking/user/id
app.use(express.urlencoded({extended: true})); // for parsing application/x-www-form-urlencoded - form data
app.use(
  session({
    secret: "babelo", // secret key for signing the session ID cookie
    resave: false, // forces session to be saved back to the session store, even if the session was never modified during the request
    saveUninitialized: true, // forces a session that is "uninitialized" to be saved to the store
  })
);
app.get("/", (req, res) => {
  res.render("index.ejs");
});
app.get("/login", (req, res) => {
  res.render("login.ejs");
});

app.listen(3000, () => {
  console.log("Server started on port 3000");
});
