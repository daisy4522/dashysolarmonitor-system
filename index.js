const express = require("express");
const path = require("path");
const mysql = require("mysql");
const cors = require("cors");
const bcrypt = require("bcrypt");
const session = require("express-session");
const dbConnection = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",

  database: "dashysolaymonitor_db",
});

const app = express();

// middleware --------- Cors , crsf ,
app.use(cors()); // enable CORS for all routes
app.use(express.json()); // for parsing application/json
app.use(express.static(path.join(__dirname, "public"))); // path -- nested routs /booking/user/id
app.use(express.urlencoded({extended: true})); // for parsing application/x-www-form-urlencoded - form data
app.use(
  session({
    secret: "babelo", // secret key for signing the session ID cookie
    resave: false, // forces session to be saved back to the session store, even if the session was never modified during the request
    saveUninitialized: true, // forces a session that is "uninitialized" to be saved to the store
  })
);
// authorizarion middleware
const installerRoutes = [
  "/Updates",
  "/dashboard/enduser",
  "/confirmdataupdate",
  "/confirmsettingsupdate",
];
const technicianRoutes = [
  ...installerRoutes,
  "/addReceptionist",
  "/addNewTechnician",
  "/confirminstallerupdate",
  "/dashboard/technician",
];
const adminRoutes = [
  ...installerRoutes,
  ...technicianRoutes,
  ...EnduserRoutes,

  "/dashboard/admin",
]; // js spread operator - combine all routes

app.use((req, res, next) => {
  console.log(req.path);

  if (req.session.user) {
    res.locals.user = req.session.user; // send user data to views/ejs
    // user islogged in  --- go ahead and check role and route they are accessing
    const userRole = req.session.user.role; // get user role from session
    if (userRole === "admin" && adminRoutes.includes(req.path)) {
      //  admin - allow access to super admin routes
      next();
    } else if (userRole === "installer" && installerRoutes.includes(req.path)) {
      // receptionist - allow access to receptionist routes
      next();
    } else if (
      userRole === "technician" &&
      technicianRoutes.includes(req.path)
    ) {
      // manager - allow access to manager routes
      next();
    } else if (userRole === "Enduser" && EnduserRoutes.includes(req.path)) {
      next();
    } else {
      // user is not authorized to access this route
      // check if the route is public
      if (
        req.path === "/" ||
        req.path === "/login" ||
        req.path === "/about" ||
        req.path === "/book" ||
        req.path === "/checkout" ||
        req.path === "/checkin" ||
        req.path === "/logout"
      ) {
        next(); // allow access to public routes
      } else {
        res.status(401).render("401.ejs");
      }
    }
  } else {
    // user is not logged in
    if (
      adminRoutes.includes(req.path) ||
      technicianRoutes.includes(req.path) ||
      installerRoutes.includes(req.path) ||
      EnduserRoutes.includes(req.path)
    ) {
      res.status(401).render("401.ejs");
    } else {
      next();
    }
  }
});

app.get("/", (req, res) => {
  res.render("index.ejs");
});
app.get("/login", (req, res) => {
  res.render("login.ejs");
});
app.get("/about", (req, res) => {
  res.render("about.ejs");
});

app.listen(3000, () => {
  console.log("Server started on port 3000");
});
