document.getElementById("formNavigator").addEventListener('click', (e) => {
    let title = document.getElementById("title");
    if (title.innerHTML == "Sign Up") {
        showSignInForm();
    } else {
        showSignUpForm();
    }
});

document.getElementById("signButton").addEventListener('click', event => {
    clearReds();
    const signInOperation = document.getElementById("signButton").innerText === "Sign in" ? true : false;
    if (signInOperation) {
        signIn();
    } else {
        signUp();
    }
})

function showSignInForm() {
    clearReds();
    clearInputs();
    document.getElementById("signButton").innerHTML = "Sign in";
    document.getElementById("nameField").style.maxHeight = "0";
    document.getElementById("confirmPasswordField").style.maxHeight = "0";
    document.getElementById("title").innerHTML = "Sign In";
    document.getElementById("p1").innerText = "Don't have an account? Click ";
    document.getElementById("p2").innerText = " to create one.";
}

function showSignUpForm() {
    clearReds();
    clearInputs();
    document.getElementById("signButton").innerHTML = "Sign up"
    document.getElementById("nameField").style.maxHeight = "60px";
    document.getElementById("confirmPasswordField").style.maxHeight = "60px";
    document.getElementById("title").innerHTML = "Sign Up";
    document.getElementById("p1").innerText = "Already have an account? Click ";
    document.getElementById("p2").innerText = " to sign in.";
}

function clearInputs() {
    document.querySelectorAll("input").forEach(input => input.value = "");
}

function clearReds() {
    document.querySelectorAll(".error").forEach(msg => msg.classList.add("hidden"));
    document.querySelectorAll(".input-field").forEach(field => field.style.border = "");
    document.getElementById("message").classList.add("hidden");
    document.getElementById("message").style.border = "";
}

async function signIn() {
    if (isEmailValid()) {
            let user = {
                email: document.forms.signForm.email.value.trim(),
                password: document.forms.signForm.password.value.trim()
            }
            let successfullyLoggedIn = await loginUser(user);

            if (successfullyLoggedIn) {
                localStorage.setItem("currentUser", document.forms.signForm.email.value.trim());
                window.location.href = "../profile.html";
            } else {
                const message = document.getElementById("message");
                message.innerText = "A user with such email does not exist."
                message.classList.remove("hidden");
            }
    };
}

async function signUp() {
    if (isEmailValid() && isNameValid()) {
        if (isPasswordValid()) {
            if (isConfirmPasswordValid()) {

                let newUser = {
                    email: document.forms.signForm.email.value.trim(),
                    firstName: document.forms.signForm.name.value.trim(),
                    password: document.forms.signForm.password.value.trim(),
                    confirmPassword: document.forms.signForm.password.value.trim()
                }
                let successfullySaved = await writeUserData(newUser);

                if (typeof successfullySaved === 'number') {
                    // Registration successful, `successfullySaved` contains the user ID
                    localStorage.setItem("currentUser", newUser.email);
                    window.location.href = "../profile.html";
                } else {
                    // Registration failed, `successfullySaved` contains the error message
                    showError(successfullySaved)
                }
            }
        }
    }
}

const isRequired = value => value === '' ? false : true;

const showError = (message) => {
    document.querySelectorAll(".error").forEach(msg => {
        msg.innerText = message;
        msg.classList.remove("hidden");
    });
};

function isNameValid() {
    const name = document.forms.signForm.name.value.trim();
    if (!isRequired(name)) {
        showError("Name cannot be blank.")
        return false;
    }

    if (name.length < 2) {
        showError("Name must be at least 2 characters long.")
        return false;
    }

    const nameRegEx = new RegExp("^([A-ZÀ-ÿ][-,a-z. ']+[ ]*)+");
    if (!nameRegEx.test(name)) {
        showError("Please, enter a valid name.")
        return false;
    }

    return true;
}

function isEmailValid() {
    const email = document.forms.signForm.email.value.trim();
    if (!isRequired(email)) {
        showError("Email cannot be blank.")
        return false;
    }

    const emailRegEx = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    if (!emailRegEx.test(email)) {
        showError("Please, enter a valid email.")
        return false;
    }

    return true;
}

function isPasswordValid() {
    const password = document.forms.signForm.password.value.trim();
    if (!isRequired(password)) {
        showError("Passsword cannot be blank.")
        return false;
    }

    const securePasswordRegEx = new RegExp("^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,})");
    if (!securePasswordRegEx.test(password)) {
        showError("Password must be at least 8 characters long with at least one lowercase character, an uppercase character, a number, and a special character.")
        return false;
    }

    return true;
}

function isConfirmPasswordValid() {
    const confirmPassword = document.forms.signForm.confirmPassword.value.trim();
    if (!isRequired(confirmPassword)) {
        showError("Please, confirm your password.")
        return false;
    }

    const password = document.forms.signForm.password.value.trim();
    if (confirmPassword != password) {
        showError("Passwords do not match.");
        return false;
    }

    return true;
}

async function writeUserData(user) {
    try {
        const response = await fetch('http://localhost:8484/users/register', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(user),
        });

        if (response.ok) {
            const data = await response.json();
            const userId = data.id;
            console.log(`Successfully registered user with ID: ${userId}`);
            return userId;
        } else {
            const data = await response.json();
            console.log(`Error registering user: ${data.msg}`);
            return data.msg; // Return the error message
        }
    } catch (error) {
        console.error(error.message);
        return "An unexpected error occurred.";
    }
}

async function loginUser(user) {
    try {
        const response = await fetch('http://localhost:8484/users/login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(user),
        });

        console.log(response);

        if (response.ok) {
            const data = await response.json();
            const userId = data.id;
            console.log(`Successfully logged user with ID: ${userId}`);
            return true;
        } else {
            console.log(`Error signing in`);
            return false;
        }
    } catch (error) {
        console.error(error.message);
        return "An unexpected error occurred.";
    }
}