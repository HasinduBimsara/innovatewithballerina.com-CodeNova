import ballerina/http;
import ballerina/io;
import ballerina/uuid;
import ballerina/crypto;
import ballerina/time;
import ballerina/file;

public function main() {
    io:println("🚀 TaskSwap Backend Starting...");
    io:println("📁 Static files server: http://localhost:8080");
    io:println("🔗 API server: http://localhost:8081/api");
    
    // Initialize data storage
    initializeStorage();
}

// File paths for data storage
const string USERS_FILE = "./data/users.json";
const string TOKENS_FILE = "./data/tokens.json";
const string TASKS_FILE = "./data/tasks.json";

function initializeStorage() {
    do {
        // Create data directory if it doesn't exist
        boolean dirExists = check file:test("./data", file:EXISTS);
        if !dirExists {
            check file:createDir("./data");
            io:println("📁 Created data directory");
        }
        
        // Initialize users file if it doesn't exist
        boolean usersFileExists = check file:test(USERS_FILE, file:EXISTS);
        if !usersFileExists {
            check io:fileWriteJson(USERS_FILE, {});
            io:println("📄 Created users.json file");
        }
        
        // Initialize tokens file if it doesn't exist
        boolean tokensFileExists = check file:test(TOKENS_FILE, file:EXISTS);
        if !tokensFileExists {
            check io:fileWriteJson(TOKENS_FILE, {});
            io:println("📄 Created tokens.json file");
        }
        
        // Initialize tasks file if it doesn't exist
        boolean tasksFileExists = check file:test(TASKS_FILE, file:EXISTS);
        if !tasksFileExists {
            check io:fileWriteJson(TASKS_FILE, {});
            io:println("📄 Created tasks.json file");
        }
        
        io:println("✅ Storage initialized successfully");
    } on fail error e {
        io:println("❌ Failed to initialize storage: " + e.message());
    }
}

// Static file service on port 8080
service / on new http:Listener(8080) {

    resource function get .(http:Caller caller, http:Request req) {
        var htmlFile = io:fileReadString("./resources/index.html");
        if (htmlFile is string) {
            http:Response res = new;
            var setTypeResult = res.setContentType("text/html");
            if (setTypeResult is error) {
                checkpanic caller->respond("Error setting content type");
                return;
            }
            res.setPayload(htmlFile);
            checkpanic caller->respond(res);
        } else {
            checkpanic caller->respond("Error reading HTML file");
        }
    }

    resource function get signup(http:Caller caller, http:Request req) {
        var htmlFile = io:fileReadString("./resources/signup.html");
        if (htmlFile is string) {
            http:Response res = new;
            var setTypeResult = res.setContentType("text/html");
            if (setTypeResult is error) {
                checkpanic caller->respond("Error setting content type");
                return;
            }
            res.setPayload(htmlFile);
            checkpanic caller->respond(res);
        } else {
            checkpanic caller->respond("Error reading signup HTML file");
        }
    }

    resource function get login(http:Caller caller, http:Request req) {
        var htmlFile = io:fileReadString("./resources/login.html");
        if (htmlFile is string) {
            http:Response res = new;
            var setTypeResult = res.setContentType("text/html");
            if (setTypeResult is error) {
                checkpanic caller->respond("Error setting content type");
                return;
            }
            res.setPayload(htmlFile);
            checkpanic caller->respond(res);
        } else {
            checkpanic caller->respond("Error reading login HTML file");
        }
    }

    resource function get giver(http:Caller caller, http:Request req) {
        var htmlFile = io:fileReadString("./resources/giver.html");
        if (htmlFile is string) {
            http:Response res = new;
            var setTypeResult = res.setContentType("text/html");
            if (setTypeResult is error) {
                checkpanic caller->respond("Error setting content type");
                return;
            }
            res.setPayload(htmlFile);
            checkpanic caller->respond(res);
        } else {
            checkpanic caller->respond("Error reading giver HTML file");
        }
    }

    resource function get seeker(http:Caller caller, http:Request req) {
        var htmlFile = io:fileReadString("./resources/seeker.html");
        if (htmlFile is string) {
            http:Response res = new;
            var setTypeResult = res.setContentType("text/html");
            if (setTypeResult is error) {
                checkpanic caller->respond("Error setting content type");
                return;
            }
            res.setPayload(htmlFile);
            checkpanic caller->respond(res);
        } else {
            checkpanic caller->respond("Error reading seeker HTML file");
        }
    }

    resource function get css/styles\.css(http:Caller caller, http:Request req) {
        var cssFile = io:fileReadString("./resources/css/styles.css");
        if (cssFile is string) {
            http:Response res = new;
            var setTypeResult = res.setContentType("text/css");
            if (setTypeResult is error) {
                checkpanic caller->respond("Error setting content type");
                return;
            }
            res.setPayload(cssFile);
            checkpanic caller->respond(res);
        } else {
            checkpanic caller->respond("Error reading CSS file");
        }
    }
}

// API service on port 8081
@http:ServiceConfig {
    cors: {
        allowOrigins: ["*"],
        allowMethods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
        allowHeaders: ["Authorization", "Content-Type"],
        allowCredentials: false
    }
}
service /api on new http:Listener(8081) {

    // Handle OPTIONS requests for CORS
    resource function options .(http:Caller caller, http:Request req) {
        http:Response res = new;
        res.setHeader("Access-Control-Allow-Origin", "*");
        res.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        res.setHeader("Access-Control-Allow-Headers", "Authorization, Content-Type");
        res.statusCode = 200;
        checkpanic caller->respond(res);
    }

    resource function options signup(http:Caller caller, http:Request req) {
        http:Response res = new;
        res.setHeader("Access-Control-Allow-Origin", "*");
        res.setHeader("Access-Control-Allow-Methods", "POST, OPTIONS");
        res.setHeader("Access-Control-Allow-Headers", "Authorization, Content-Type");
        res.statusCode = 200;
        checkpanic caller->respond(res);
    }

    resource function options login(http:Caller caller, http:Request req) {
        http:Response res = new;
        res.setHeader("Access-Control-Allow-Origin", "*");
        res.setHeader("Access-Control-Allow-Methods", "POST, OPTIONS");
        res.setHeader("Access-Control-Allow-Headers", "Authorization, Content-Type");
        res.statusCode = 200;
        checkpanic caller->respond(res);
    }

    resource function options tasks(http:Caller caller, http:Request req) {
        http:Response res = new;
        res.setHeader("Access-Control-Allow-Origin", "*");
        res.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        res.setHeader("Access-Control-Allow-Headers", "Authorization, Content-Type");
        res.statusCode = 200;
        checkpanic caller->respond(res);
    }

    resource function options userProfile(http:Caller caller, http:Request req) {
        http:Response res = new;
        res.setHeader("Access-Control-Allow-Origin", "*");
        res.setHeader("Access-Control-Allow-Methods", "GET, OPTIONS");
        res.setHeader("Access-Control-Allow-Headers", "Authorization, Content-Type");
        res.statusCode = 200;
        checkpanic caller->respond(res);
    }

    // Health check endpoint
    resource function get health(http:Caller caller, http:Request req) {
        do {
            json users = check io:fileReadJson(USERS_FILE);
            json tokens = check io:fileReadJson(TOKENS_FILE);
            json tasks = check io:fileReadJson(TASKS_FILE);
            
            map<json> usersMap = <map<json>>users;
            map<json> tokensMap = <map<json>>tokens;
            map<json> tasksMap = <map<json>>tasks;
            
            json healthResponse = {
                "status": "healthy",
                "timestamp": time:utcNow(),
                "service": "TaskSwap Backend",
                "database": "File-based storage",
                "users_count": usersMap.length(),
                "active_tokens": tokensMap.length(),
                "tasks_count": tasksMap.length()
            };
            
            http:Response res = new;
            res.setJsonPayload(healthResponse);
            res.setHeader("Access-Control-Allow-Origin", "*");
            checkpanic caller->respond(res);
            
        } on fail error e {
            json errorResponse = {
                "status": "error",
                "message": e.message()
            };
            
            http:Response res = new;
            res.statusCode = 500;
            res.setJsonPayload(errorResponse);
            res.setHeader("Access-Control-Allow-Origin", "*");
            checkpanic caller->respond(res);
        }
    }

    // User signup endpoint
    resource function post signup(http:Caller caller, http:Request req) {
        do {
            json payload = check req.getJsonPayload();
            
            // Extract fields from payload
            json|error fullnameField = payload.fullname;
            json|error emailField = payload.email;
            json|error passwordField = payload.password;
            json|error roleField = payload.role;
            json|error termsField = payload.terms;
            json|error newsletterField = payload.newsletter;
            
            if fullnameField is error || emailField is error || passwordField is error || 
               roleField is error || termsField is error {
                http:Response res = new;
                res.statusCode = 400;
                res.setJsonPayload({
                    "success": false,
                    "message": "Missing required fields"
                });
                res.setHeader("Access-Control-Allow-Origin", "*");
                checkpanic caller->respond(res);
                return;
            }
            
            string fullname = fullnameField.toString().trim();
            string email = emailField.toString().trim();
            string password = passwordField.toString();
            string role = roleField.toString();
            boolean terms = termsField == true;
            boolean newsletter = newsletterField == true;
            
            // Validate required fields
            if fullname == "" || email == "" || password == "" || role == "" {
                http:Response res = new;
                res.statusCode = 400;
                res.setJsonPayload({
                    "success": false,
                    "message": "All required fields must be filled"
                });
                res.setHeader("Access-Control-Allow-Origin", "*");
                checkpanic caller->respond(res);
                return;
            }

            // Validate email format
            if !isValidEmail(email) {
                http:Response res = new;
                res.statusCode = 400;
                res.setJsonPayload({
                    "success": false,
                    "message": "Invalid email format"
                });
                res.setHeader("Access-Control-Allow-Origin", "*");
                checkpanic caller->respond(res);
                return;
            }

            // Validate password strength
            if password.length() < 6 {
                http:Response res = new;
                res.statusCode = 400;
                res.setJsonPayload({
                    "success": false,
                    "message": "Password must be at least 6 characters long"
                });
                res.setHeader("Access-Control-Allow-Origin", "*");
                checkpanic caller->respond(res);
                return;
            }

            // Check if terms are accepted
            if !terms {
                http:Response res = new;
                res.statusCode = 400;
                res.setJsonPayload({
                    "success": false,
                    "message": "You must accept the terms and conditions"
                });
                res.setHeader("Access-Control-Allow-Origin", "*");
                checkpanic caller->respond(res);
                return;
            }

            // Read existing users from file
            json usersJson = check io:fileReadJson(USERS_FILE);
            map<json> users = <map<json>>usersJson;
            
            string emailKey = email.toLowerAscii();
            
            // Check if user already exists
            if users.hasKey(emailKey) {
                http:Response res = new;
                res.statusCode = 409;
                res.setJsonPayload({
                    "success": false,
                    "message": "User with this email already exists"
                });
                res.setHeader("Access-Control-Allow-Origin", "*");
                checkpanic caller->respond(res);
                return;
            }

            // Hash password
            string hashedPassword = hashPassword(password);
            
            // Create user
            string id = uuid:createType1AsString();
            string currentTime = time:utcToString(time:utcNow());
            
            User user = {
                id: id,
                fullname: fullname,
                email: emailKey,
                password: hashedPassword,
                role: role,
                terms: terms,
                newsletter: newsletter,
                createdAt: currentTime,
                updatedAt: currentTime
            };
            
            // Add user to users map
            users[emailKey] = user.toJson();
            
            // Save to file
            check io:fileWriteJson(USERS_FILE, users);
            
            io:println("✅ User created: " + email);
            
            // Generate token
            string token = check generateAndSaveToken(emailKey, role);
            
            http:Response res = new;
            res.statusCode = 201;
            res.setJsonPayload({
                "success": true,
                "message": "Account created successfully! Welcome to TaskSwap!",
                "data": {
                    "token": token,
                    "user": {
                        "id": user.id,
                        "fullname": user.fullname,
                        "email": user.email,
                        "role": user.role
                    }
                }
            });
            res.setHeader("Access-Control-Allow-Origin", "*");
            checkpanic caller->respond(res);
            
        } on fail error e {
            io:println("❌ Signup error: " + e.message());
            http:Response res = new;
            res.statusCode = 500;
            res.setJsonPayload({
                "success": false,
                "message": "Internal server error: " + e.message()
            });
            res.setHeader("Access-Control-Allow-Origin", "*");
            checkpanic caller->respond(res);
        }
    }

    // User login endpoint
    resource function post login(http:Caller caller, http:Request req) {
        do {
            json payload = check req.getJsonPayload();
            
            // Extract fields from payload
            json|error emailField = payload.email;
            json|error passwordField = payload.password;
            json|error roleField = payload.role;
            
            if emailField is error || passwordField is error || roleField is error {
                http:Response res = new;
                res.statusCode = 400;
                res.setJsonPayload({
                    "success": false,
                    "message": "Missing required fields"
                });
                res.setHeader("Access-Control-Allow-Origin", "*");
                checkpanic caller->respond(res);
                return;
            }
            
            string email = emailField.toString().trim();
            string password = passwordField.toString();
            string role = roleField.toString();
            
            // Validate required fields
            if email == "" || password == "" || role == "" {
                http:Response res = new;
                res.statusCode = 400;
                res.setJsonPayload({
                    "success": false,
                    "message": "All fields are required"
                });
                res.setHeader("Access-Control-Allow-Origin", "*");
                checkpanic caller->respond(res);
                return;
            }

            // Read users from file
            json usersJson = check io:fileReadJson(USERS_FILE);
            map<json> users = <map<json>>usersJson;
            
            string emailKey = email.toLowerAscii();
            
            // Check if user exists
            if !users.hasKey(emailKey) {
                http:Response res = new;
                res.statusCode = 401;
                res.setJsonPayload({
                    "success": false,
                    "message": "Invalid email or password"
                });
                res.setHeader("Access-Control-Allow-Origin", "*");
                checkpanic caller->respond(res);
                return;
            }

            json userData = users[emailKey] ?: {};
            
            // Verify password
            json|error passwordFieldData = userData.password;
            if passwordFieldData is error {
                http:Response res = new;
                res.statusCode = 500;
                res.setJsonPayload({
                    "success": false,
                    "message": "Invalid user data"
                });
                res.setHeader("Access-Control-Allow-Origin", "*");
                checkpanic caller->respond(res);
                return;
            }

            string storedPassword = passwordFieldData.toString();
            if !verifyPassword(password, storedPassword) {
                http:Response res = new;
                res.statusCode = 401;
                res.setJsonPayload({
                    "success": false,
                    "message": "Invalid email or password"
                });
                res.setHeader("Access-Control-Allow-Origin", "*");
                checkpanic caller->respond(res);
                return;
            }
            
            // Check role
            json|error roleFieldData = userData.role;
            if roleFieldData is error {
                http:Response res = new;
                res.statusCode = 500;
                res.setJsonPayload({
                    "success": false,
                    "message": "Invalid user data"
                });
                res.setHeader("Access-Control-Allow-Origin", "*");
                checkpanic caller->respond(res);
                return;
            }

            string userRole = roleFieldData.toString();
            if userRole != role && userRole != "both" {
                http:Response res = new;
                res.statusCode = 401;
                res.setJsonPayload({
                    "success": false,
                    "message": "Invalid role selected"
                });
                res.setHeader("Access-Control-Allow-Origin", "*");
                checkpanic caller->respond(res);
                return;
            }
            
            io:println("✅ User logged in: " + email);
            
            // Generate token
            string token = check generateAndSaveToken(emailKey, userRole);
            
            json|error idField = userData.id;
            json|error fullnameField = userData.fullname;
            
            string userId = idField is json ? idField.toString() : "";
            string fullname = fullnameField is json ? fullnameField.toString() : "";
            
            http:Response res = new;
            res.statusCode = 200;
            res.setJsonPayload({
                "success": true,
                "message": "Login successful! Welcome back!",
                "data": {
                    "token": token,
                    "user": {
                        "id": userId,
                        "fullname": fullname,
                        "email": emailKey,
                        "role": userRole
                    }
                }
            });
            res.setHeader("Access-Control-Allow-Origin", "*");
            checkpanic caller->respond(res);
            
        } on fail error e {
            io:println("❌ Login error: " + e.message());
            http:Response res = new;
            res.statusCode = 500;
            res.setJsonPayload({
                "success": false,
                "message": "Internal server error: " + e.message()
            });
            res.setHeader("Access-Control-Allow-Origin", "*");
            checkpanic caller->respond(res);
        }
    }

    // Get user profile endpoint (protected)
    resource function get userProfile(http:Caller caller, http:Request req) {
        do {
            // Verify token
            string|error userEmail = verifyTokenFromRequest(req);
            if userEmail is error {
                http:Response res = new;
                res.statusCode = 401;
                res.setJsonPayload({
                    "success": false,
                    "message": "Unauthorized: " + userEmail.message()
                });
                res.setHeader("Access-Control-Allow-Origin", "*");
                checkpanic caller->respond(res);
                return;
            }

            // Get user from file
            json usersJson = check io:fileReadJson(USERS_FILE);
            map<json> users = <map<json>>usersJson;
            
            if !users.hasKey(userEmail) {
                http:Response res = new;
                res.statusCode = 404;
                res.setJsonPayload({
                    "success": false,
                    "message": "User not found"
                });
                res.setHeader("Access-Control-Allow-Origin", "*");
                checkpanic caller->respond(res);
                return;
            }

            json userData = users[userEmail] ?: {};
            
            json|error idField = userData.id;
            json|error fullnameField = userData.fullname;
            json|error roleField = userData.role;
            json|error createdAtField = userData.createdAt;
            
            http:Response res = new;
            res.statusCode = 200;
            res.setJsonPayload({
                "success": true,
                "message": "User profile retrieved successfully",
                "data": {
                    "user": {
                        "id": idField is json ? idField.toString() : "",
                        "fullname": fullnameField is json ? fullnameField.toString() : "",
                        "email": userEmail,
                        "role": roleField is json ? roleField.toString() : "",
                        "createdAt": createdAtField is json ? createdAtField.toString() : ""
                    }
                }
            });
            res.setHeader("Access-Control-Allow-Origin", "*");
            checkpanic caller->respond(res);
            
        } on fail error e {
            io:println("❌ Get profile error: " + e.message());
            http:Response res = new;
            res.statusCode = 500;
            res.setJsonPayload({
                "success": false,
                "message": "Internal server error: " + e.message()
            });
            res.setHeader("Access-Control-Allow-Origin", "*");
            checkpanic caller->respond(res);
        }
    }

    // Post a new task endpoint (protected)
    resource function post tasks(http:Caller caller, http:Request req) {
        do {
            // Verify token
            string|error userEmail = verifyTokenFromRequest(req);
            if userEmail is error {
                http:Response res = new;
                res.statusCode = 401;
                res.setJsonPayload({
                    "success": false,
                    "message": "Unauthorized: " + userEmail.message()
                });
                res.setHeader("Access-Control-Allow-Origin", "*");
                checkpanic caller->respond(res);
                return;
            }

            // Get user to check role
            json usersJson = check io:fileReadJson(USERS_FILE);
            map<json> users = <map<json>>usersJson;
            
            if !users.hasKey(userEmail) {
                http:Response res = new;
                res.statusCode = 404;
                res.setJsonPayload({
                    "success": false,
                    "message": "User not found"
                });
                res.setHeader("Access-Control-Allow-Origin", "*");
                checkpanic caller->respond(res);
                return;
            }

            json userData = users[userEmail] ?: {};
            json|error roleField = userData.role;
            json|error idField = userData.id;
            
            if roleField is error || idField is error {
                http:Response res = new;
                res.statusCode = 500;
                res.setJsonPayload({
                    "success": false,
                    "message": "Invalid user data"
                });
                res.setHeader("Access-Control-Allow-Origin", "*");
                checkpanic caller->respond(res);
                return;
            }
            
            string userRole = roleField.toString();
            string userId = idField.toString();
            
            // Check if user can post tasks
            if userRole != "taskgiver" && userRole != "both" {
                http:Response res = new;
                res.statusCode = 403;
                res.setJsonPayload({
                    "success": false,
                    "message": "Unauthorized: Only task givers can post tasks"
                });
                res.setHeader("Access-Control-Allow-Origin", "*");
                checkpanic caller->respond(res);
                return;
            }

            json payload = check req.getJsonPayload();
            
            // Extract task fields
            json|error titleField = payload.title;
            json|error descriptionField = payload.description;
            json|error locationField = payload.location;
            json|error categoryField = payload.category;
            json|error budgetField = payload.budget;
            json|error imageField = payload.image;
            json|error urgentField = payload.urgent;
            
            if titleField is error || descriptionField is error || locationField is error || 
               categoryField is error || budgetField is error {
                http:Response res = new;
                res.statusCode = 400;
                res.setJsonPayload({
                    "success": false,
                    "message": "Missing required task fields"
                });
                res.setHeader("Access-Control-Allow-Origin", "*");
                checkpanic caller->respond(res);
                return;
            }
            
            string title = titleField.toString().trim();
            string description = descriptionField.toString().trim();
            string location = locationField.toString().trim();
            string category = categoryField.toString().trim();
            float budget = <float>budgetField;
            string? image = imageField is json ? imageField.toString() : ();
            boolean urgent = urgentField == true;
            
            // Validate required fields
            if title == "" || description == "" || location == "" || category == "" || budget <= 0.0 {
                http:Response res = new;
                res.statusCode = 400;
                res.setJsonPayload({
                    "success": false,
                    "message": "All required fields must be filled and budget must be greater than 0"
                });
                res.setHeader("Access-Control-Allow-Origin", "*");
                checkpanic caller->respond(res);
                return;
            }

            // Create task
            string taskId = uuid:createType1AsString();
            string currentTime = time:utcToString(time:utcNow());
            
            Task task = {
                id: taskId,
                title: title,
                description: description,
                location: location,
                category: category,
                budget: budget,
                image: image,
                status: "active",
                date: currentTime,
                giverId: userId,
                assignedSeekerId: (),
                urgent: urgent,
                createdAt: currentTime,
                updatedAt: currentTime
            };
            
            // Read existing tasks and add new task
            json tasksJson = check io:fileReadJson(TASKS_FILE);
            map<json> tasks = <map<json>>tasksJson;
            tasks[taskId] = task.toJson();
            
            // Save to file
            check io:fileWriteJson(TASKS_FILE, tasks);
            
            io:println("✅ Task created: " + title + " by " + userEmail);
            
            http:Response res = new;
            res.statusCode = 201;
            res.setJsonPayload({
                "success": true,
                "message": "Task posted successfully!",
                "data": {
                    "task": {
                        "id": task.id,
                        "title": task.title,
                        "description": task.description,
                        "location": task.location,
                        "category": task.category,
                        "budget": task.budget,
                        "image": task.image,
                        "status": task.status,
                        "date": task.date,
                        "urgent": task.urgent
                    }
                }
            });
            res.setHeader("Access-Control-Allow-Origin", "*");
            checkpanic caller->respond(res);
            
        } on fail error e {
            io:println("❌ Post task error: " + e.message());
            http:Response res = new;
            res.statusCode = 500;
            res.setJsonPayload({
                "success": false,
                "message": "Internal server error: " + e.message()
            });
            res.setHeader("Access-Control-Allow-Origin", "*");
            checkpanic caller->respond(res);
        }
    }

    // Get available tasks endpoint (protected)
    resource function get tasks(http:Caller caller, http:Request req) {
        do {
            // Verify token
            string|error userEmail = verifyTokenFromRequest(req);
            if userEmail is error {
                http:Response res = new;
                res.statusCode = 401;
                res.setJsonPayload({
                    "success": false,
                    "message": "Unauthorized: " + userEmail.message()
                });
                res.setHeader("Access-Control-Allow-Origin", "*");
                checkpanic caller->respond(res);
                return;
            }

            // Get user to check role
            json usersJson = check io:fileReadJson(USERS_FILE);
            map<json> users = <map<json>>usersJson;
            
            if !users.hasKey(userEmail) {
                http:Response res = new;
                res.statusCode = 404;
                res.setJsonPayload({
                    "success": false,
                    "message": "User not found"
                });
                res.setHeader("Access-Control-Allow-Origin", "*");
                checkpanic caller->respond(res);
                return;
            }

            json userData = users[userEmail] ?: {};
            json|error roleField = userData.role;
            json|error idField = userData.id;
            
            if roleField is error || idField is error {
                http:Response res = new;
                res.statusCode = 500;
                res.setJsonPayload({
                    "success": false,
                    "message": "Invalid user data"
                });
                res.setHeader("Access-Control-Allow-Origin", "*");
                checkpanic caller->respond(res);
                return;
            }
            
                        string userRole = roleField.toString();
            string userId = idField.toString();
            
            // Get tasks from file
            json tasksJson = check io:fileReadJson(TASKS_FILE);
            map<json> tasks = <map<json>>tasksJson;
            
            // Convert tasks to response format
            json[] taskList = [];
            foreach var [taskId, taskData] in tasks.entries() {
                json|error giverIdField = taskData.giverId;
                json|error statusField = taskData.status;
                
                if giverIdField is json && statusField is json {
                    string taskGiverId = giverIdField.toString();
                    string taskStatus = statusField.toString();
                    
                    // Filter tasks based on user role
                    boolean includeTask = false;
                    if userRole == "taskseeker" {
                        // Task seekers see active tasks that are not their own
                        includeTask = taskStatus == "active" && taskGiverId != userId;
                    } else if userRole == "taskgiver" {
                        // Task givers see their own tasks
                        includeTask = taskGiverId == userId;
                    } else if userRole == "both" {
                        // Users with both roles see all active tasks
                        includeTask = taskStatus == "active";
                    }
                    
                    if includeTask {
                        json|error titleField = taskData.title;
                        json|error descriptionField = taskData.description;
                        json|error locationField = taskData.location;
                        json|error categoryField = taskData.category;
                        json|error budgetField = taskData.budget;
                        json|error imageField = taskData.image;
                        json|error dateField = taskData.date;
                        json|error assignedSeekerIdField = taskData.assignedSeekerId;
                        json|error urgentField = taskData.urgent;
                        
                        taskList.push({
                            "id": taskId,
                            "title": titleField is json ? titleField.toString() : "",
                            "description": descriptionField is json ? descriptionField.toString() : "",
                            "location": locationField is json ? locationField.toString() : "",
                            "category": categoryField is json ? categoryField.toString() : "",
                            "budget": budgetField is json ? budgetField : 0,
                            "image": imageField is json ? imageField.toString() : (),
                            "status": taskStatus,
                            "date": dateField is json ? dateField.toString() : "",
                            "giverId": taskGiverId,
                            "assignedSeekerId": assignedSeekerIdField is json ? assignedSeekerIdField.toString() : (),
                            "urgent": urgentField is json ? urgentField : false
                        });
                    }
                }
            }
            
            http:Response res = new;
            res.statusCode = 200;
            res.setJsonPayload({
                "success": true,
                "message": "Tasks retrieved successfully",
                "count": taskList.length(),
                "data": taskList
            });
            res.setHeader("Access-Control-Allow-Origin", "*");
            checkpanic caller->respond(res);
            
        } on fail error e {
            io:println("❌ Get tasks error: " + e.message());
            http:Response res = new;
            res.statusCode = 500;
            res.setJsonPayload({
                "success": false,
                "message": "Internal server error: " + e.message()
            });
            res.setHeader("Access-Control-Allow-Origin", "*");
            checkpanic caller->respond(res);
        }
    }

    // Get all users endpoint (admin/debug)
    resource function get users(http:Caller caller, http:Request req) {
        do {
            json usersJson = check io:fileReadJson(USERS_FILE);
            map<json> users = <map<json>>usersJson;
            
            json[] userList = [];
            foreach var [email, userData] in users.entries() {
                json|error idField = userData.id;
                json|error fullnameField = userData.fullname;
                json|error roleField = userData.role;
                json|error createdAtField = userData.createdAt;
                json|error termsField = userData.terms;
                json|error newsletterField = userData.newsletter;
                
                userList.push({
                    "id": idField is json ? idField.toString() : "",
                    "email": email,
                    "fullname": fullnameField is json ? fullnameField.toString() : "",
                    "role": roleField is json ? roleField.toString() : "",
                    "createdAt": createdAtField is json ? createdAtField.toString() : "",
                    "terms": termsField is json ? termsField : false,
                    "newsletter": newsletterField is json ? newsletterField : false
                });
            }
            
            json response = {
                "success": true,
                "count": users.length(),
                "users": userList
            };
            
            http:Response res = new;
            res.setJsonPayload(response);
            res.setHeader("Access-Control-Allow-Origin", "*");
            checkpanic caller->respond(res);
            
        } on fail error e {
            json errorResponse = {
                "success": false,
                "message": "Error fetching users: " + e.message()
            };
            
            http:Response res = new;
            res.statusCode = 500;
            res.setJsonPayload(errorResponse);
            res.setHeader("Access-Control-Allow-Origin", "*");
            checkpanic caller->respond(res);
        }
    }

    // Logout endpoint
    resource function post logout(http:Caller caller, http:Request req) {
        do {
            string|http:HeaderNotFoundError authHeader = req.getHeader("Authorization");
            
            if authHeader is http:HeaderNotFoundError {
                http:Response res = new;
                res.statusCode = 400;
                res.setJsonPayload({
                    "success": false,
                    "message": "No token provided"
                });
                res.setHeader("Access-Control-Allow-Origin", "*");
                checkpanic caller->respond(res);
                return;
            }

            if authHeader.startsWith("Bearer ") {
                string token = authHeader.substring(7);
                
                // Remove token from file
                json tokensJson = check io:fileReadJson(TOKENS_FILE);
                map<json> tokens = <map<json>>tokensJson;
                
                if tokens.hasKey(token) {
                    _ = tokens.remove(token);
                    check io:fileWriteJson(TOKENS_FILE, tokens);
                    io:println("🚪 Token removed from storage");
                }
            }

            http:Response res = new;
            res.statusCode = 200;
            res.setJsonPayload({
                "success": true,
                "message": "Logged out successfully"
            });
            res.setHeader("Access-Control-Allow-Origin", "*");
            checkpanic caller->respond(res);
            
        } on fail error e {
            io:println("❌ Logout error: " + e.message());
            http:Response res = new;
            res.statusCode = 500;
            res.setJsonPayload({
                "success": false,
                "message": "Internal server error: " + e.message()
            });
            res.setHeader("Access-Control-Allow-Origin", "*");
            checkpanic caller->respond(res);
        }
    }

    // Delete expired tokens endpoint (cleanup)
    resource function post cleanup(http:Caller caller, http:Request req) {
        do {
            json tokensJson = check io:fileReadJson(TOKENS_FILE);
            map<json> tokens = <map<json>>tokensJson;
            
            int currentTime = <int>time:utcNow()[0];
            int deletedCount = 0;
            
            // Create a new map without expired tokens
            map<json> validTokens = {};
            foreach var [token, tokenData] in tokens.entries() {
                json|error expiresAtField = tokenData.expiresAt;
                if expiresAtField is json {
                    int expiresAt = <int>expiresAtField;
                    if expiresAt > currentTime {
                        validTokens[token] = tokenData;
                    } else {
                        deletedCount += 1;
                    }
                }
            }
            
            // Save the cleaned tokens back to file
            check io:fileWriteJson(TOKENS_FILE, validTokens);
            
            io:println("🧹 Cleaned up " + deletedCount.toString() + " expired tokens");
            
            http:Response res = new;
            res.statusCode = 200;
            res.setJsonPayload({
                "success": true,
                "message": "Cleanup completed",
                "deletedTokens": deletedCount
            });
            res.setHeader("Access-Control-Allow-Origin", "*");
            checkpanic caller->respond(res);
            
        } on fail error e {
            io:println("❌ Cleanup error: " + e.message());
            http:Response res = new;
            res.statusCode = 500;
            res.setJsonPayload({
                "success": false,
                "message": "Internal server error: " + e.message()
            });
            res.setHeader("Access-Control-Allow-Origin", "*");
            checkpanic caller->respond(res);
        }
    }
}

// Type definitions
public type User record {|
    readonly string id;
    string fullname;
    string email;
    string password;
    string role;
    boolean terms;
    boolean newsletter;
    string createdAt;
    string updatedAt;
|};

public type Task record {|
    readonly string id;
    string title;
    string description;
    string location;
    string category;
    float budget;
    string? image;
    string status; // "active", "completed", "assigned", "cancelled"
    string date;
    string giverId;
    string? assignedSeekerId;
    boolean urgent;
    string createdAt;
    string updatedAt;
|};

public type TokenRecord record {|
    string token;
    string email;
    string role;
    int createdAt;
    int expiresAt;
|};

// Utility functions
function isValidEmail(string email) returns boolean {
    return email.includes("@") && email.includes(".") && email.length() > 5;
}

function hashPassword(string password) returns string {
    byte[] passwordBytes = password.toBytes();
    byte[] hashedBytes = crypto:hashSha256(passwordBytes);
    return hashedBytes.toBase64();
}

function verifyPassword(string password, string hashedPassword) returns boolean {
    string hashedInput = hashPassword(password);
    return hashedInput == hashedPassword;
}

function generateAndSaveToken(string email, string role) returns string|error {
    string tokenData = email + ":" + role + ":" + time:utcNow()[0].toString() + ":" + uuid:createType4AsString();
    byte[] tokenBytes = tokenData.toBytes();
    byte[] hashedBytes = crypto:hashSha256(tokenBytes);
    string token = hashedBytes.toBase64();
    
    int currentTime = <int>time:utcNow()[0];
    TokenRecord tokenRecord = {
        token: token,
        email: email,
        role: role,
        createdAt: currentTime,
        expiresAt: currentTime + 86400 // 24 hours
    };
    
    // Save token to file
    json tokensJson = check io:fileReadJson(TOKENS_FILE);
    map<json> tokens = <map<json>>tokensJson;
    tokens[token] = tokenRecord.toJson();
    check io:fileWriteJson(TOKENS_FILE, tokens);
    
    io:println("🔑 Token generated and saved");
    
    return token;
}

function verifyTokenFromRequest(http:Request req) returns string|error {
    string|http:HeaderNotFoundError authHeader = req.getHeader("Authorization");
    
    if authHeader is http:HeaderNotFoundError {
        return error("No Authorization header found");
    }
    
    if !authHeader.startsWith("Bearer ") {
        return error("Invalid Authorization header format");
    }
    
    string token = authHeader.substring(7);
    
    // Verify token in file
    json tokensJson = check io:fileReadJson(TOKENS_FILE);
    map<json> tokens = <map<json>>tokensJson;
    
    if !tokens.hasKey(token) {
        return error("Invalid token");
    }
    
    json tokenData = tokens[token] ?: {};
    json|error expiresAtField = tokenData.expiresAt;
    json|error emailField = tokenData.email;
    
    if expiresAtField is error || emailField is error {
        return error("Invalid token data");
    }
    
    int expiresAt = <int>expiresAtField;
    int currentTime = <int>time:utcNow()[0];
    
    if currentTime > expiresAt {
        // Remove expired token
        _ = tokens.remove(token);
        check io:fileWriteJson(TOKENS_FILE, tokens);
        return error("Token expired");
    }
    
    return emailField.toString();
}

function cleanupExpiredTokens() {
    do {
        json tokensJson = check io:fileReadJson(TOKENS_FILE);
        map<json> tokens = <map<json>>tokensJson;
        
        int currentTime = <int>time:utcNow()[0];
        int deletedCount = 0;
        
        // Create a new map without expired tokens
        map<json> validTokens = {};
        foreach var [token, tokenData] in tokens.entries() {
            json|error expiresAtField = tokenData.expiresAt;
            if expiresAtField is json {
                int expiresAt = <int>expiresAtField;
                if expiresAt > currentTime {
                    validTokens[token] = tokenData;
                } else {
                    deletedCount += 1;
                }
            }
        }
        
        // Save the cleaned tokens back to file
        check io:fileWriteJson(TOKENS_FILE, validTokens);
        
        if deletedCount > 0 {
            io:println("🧹 Auto-cleanup: Removed " + deletedCount.toString() + " expired tokens");
        }
    } on fail error e {
        io:println("❌ Auto-cleanup error: " + e.message());
    }
}