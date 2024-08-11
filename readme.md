# study-dotenv
Managing environment variables for different projects and environments can be a tedious and error-prone process. Manually exporting variables with their corresponding values for each project, remembering them, and repeating the process across different environments is laborious and inefficient. 

This is where `dotenv` comes in. Dotenv simplifies the management of environment variables by allowing you to store them in a `.env` file and load them into your application's environment. This approach offers several advantages:

* **Centralized Configuration:** All your environment variables are stored in a single file, making it easy to manage and update them.
* **Environment-Specific Settings:** You can create different `.env` files for different environments (development, testing, production), keeping configurations separate and organized.
* **Improved Security:** Sensitive data like API keys and database passwords are not hardcoded into your application, reducing the risk of accidental exposure.
* **Simplified Development Workflow:** Developers can easily switch between environments without manually setting and resetting environment variables.

## Implementation in Bash and Zsh

Here's how to implement automatic `.env` loading in Bash and Zsh:

### Bash Implementation

Add the following function to your `.bashrc` file:

```bash
load_env_file() {
    if [ -f .env ]; then
        export $(grep -v '^#' .env | xargs)
    fi
}

# Hook into the directory change process
PROMPT_COMMAND="load_env_file; $PROMPT_COMMAND"
```

### Zsh Implementation

Add the following function to your `.zshrc` file:

```zsh
# Add this function to .zshrc or .bashrc
load_env_file() {
    if [ -f .env ]; then
        export $(grep -v '^#' .env | xargs)
    fi
}

# Hook into the directory change process
chpwd() {
    load_env_file
}
```

### Example `.env` file

```.env
# Development settings
DOMAIN=example.org
ADMIN_EMAIL=admin@${DOMAIN}
ROOT_URL=${DOMAIN}/app
```

This script defines a function `load_env_file` that checks for the presence of a `.env` file in the current directory. If it exists, it reads the file, ignoring lines starting with `#` (comments), and exports the key-value pairs as environment variables.

The `chpwd` function in Zsh (or `PROMPT_COMMAND` in Bash) ensures that the `load_env_file` function is called every time you change directories, automatically loading the appropriate `.env` file.

## Exposing Environment Variables in Your Prompt

You can display specific environment variables in your shell prompt for quick reference. Here's how to display `AWS_PROFILE` and `AWS_REGION` in your Zsh prompt:

```zsh
RPROMPT='%F{green}$AWS_PROFILE/$AWS_REGION%f'
```

This will show the values of `AWS_PROFILE` and `AWS_REGION` in green on the right side of your prompt.

## Python-dotenv: Simplifying Environment Variable Management in Python

The Python `dotenv` library provides a convenient way to load environment variables from `.env` files into your Python application.

### Installation

```bash
pip install python-dotenv
```

### Basic Usage

```python
from dotenv import load_dotenv

load_dotenv()  # take environment variables from .env.

# Access environment variables using os.environ or os.getenv
domain = os.environ.get("DOMAIN")
print(f"Domain: {domain}")
```

This code snippet imports the `load_dotenv` function and calls it to load environment variables from the `.env` file. You can then access these variables using `os.environ.get("VARIABLE_NAME")` or `os.getenv("VARIABLE_NAME")`.

### Using dotenv with Flask

```python
from flask import Flask
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)

@app.route("/")
def index():
    domain = os.environ.get("DOMAIN")
    return f"Hello from {domain}!"

if __name__ == "__main__":
    app.run(debug=True)
```

### Using dotenv with Click

```python
import click
from dotenv import load_dotenv

load_dotenv()

@click.command()
def my_command():
    api_key = os.environ.get("API_KEY")
    click.echo(f"Using API key: {api_key}")

if __name__ == "__main__":
    my_command()
```

Alternativly:

````python
import click
from dotenv import load_dotenv

load_dotenv()

@click.command()
@click.option('--api-key', envvar='API_KEY', help='Your API key')
def my_command(api_key):
    click.echo(f"Using API key: {api_key}")

if __name__ == "__main__":
    my_command()
```

### Using dotenv with LangChain

```python
from langchain.llms import OpenAI
from dotenv import load_dotenv

load_dotenv()

llm = OpenAI(openai_api_key=os.environ.get("OPENAI_API_KEY"))
# Use the llm object as needed
```

In these examples, `dotenv` loads the environment variables from the `.env` file, allowing you to access them within your Flask, Click, or LangChain applications without hardcoding sensitive information.

## Managing Different Environments with Dotenv

When working with multiple environments (development, staging, acceptance, production), it's crucial to keep configurations separate and organized. Dotenv simplifies this by allowing you to use different `.env` files for each environment.

### Naming Convention

A common naming convention for environment-specific `.env` files is:

* `.env.development` or `.env.dev`
* `.env.staging` or `.env.stg`
* `.env.acceptance` or `.env.acc`
* `.env.production` or `.env.prod`

### Example Environment Variables

Here's an example of how you might configure different variables in each environment:

**`.env.dev` (Development)**

```
DEBUG=True
DATABASE_URL=sqlite:///dev.db
SECRET_KEY=dev_secret_key
```

**`.env.stg` (Staging)**

```
DEBUG=False
DATABASE_URL=postgresql://user:password@staging_db_host/staging_db
SECRET_KEY=stg_secret_key
```

**`.env.acc` (Acceptance)**

```
DEBUG=False
DATABASE_URL=postgresql://user:password@acceptance_db_host/acceptance_db
SECRET_KEY=acc_secret_key
```

**`.env.prod` (Production)**

```
DEBUG=False
DATABASE_URL=postgresql://user:password@production_db_host/production_db
SECRET_KEY=prod_secret_key
```

### Workflow

1. **Create Environment-Specific `.env` Files:** Create the `.env` files mentioned above, each with the appropriate configuration for its respective environment.

2. **Load the Correct `.env` File:** In your application, use `load_dotenv` to load the correct file based on the current environment. You can determine the environment using an environment variable like `ENVIRONMENT` or `APP_ENV`.

   ```python
   from dotenv import load_dotenv
   import os

   environment = os.environ.get("ENVIRONMENT", "development")  # Default to development

   if environment == "development":
       load_dotenv(".env.dev")
   elif environment == "staging":
       load_dotenv(".env.stg")
   elif environment == "acceptance":
       load_dotenv(".env.acc")
   elif environment == "production":
       load_dotenv(".env.prod")

   # ... rest of your application code ...
   ```

### GitLab CI Pipeline Example

Here's an example of a GitLab CI pipeline that builds and deploys a simple Flask app to different environments using environment-specific `.env` files:

```yaml
stages:
  - build
  - deploy

build:
  stage: build
  image: python:3.9
  script:
    - pip install -r requirements.txt
    - python setup.py install

deploy_staging:
  stage: deploy
  image: python:3.9
  environment:
    name: staging
  variables:
    ENVIRONMENT: "staging"
    # Other staging-specific variables
  script:
    - python deploy_script.py

deploy_production:
  stage: deploy
  image: python:3.9
  environment:
    name: production
  variables:
    ENVIRONMENT: "production"
    # Other production-specific variables
  script:
    - python deploy_script.py
```

In this pipeline:

* The `build` stage builds the application.
* The `deploy_staging` and `deploy_production` stages deploy the application to staging and production, respectively.
* The `ENVIRONMENT` variable is set appropriately for each stage, ensuring that the correct `.env` file is loaded.

Remember to replace `deploy_script.py` with your actual deployment script.

### Important Considerations

* **Security:** Never commit your `.env` files containing sensitive information like passwords and API keys to your Git repository. Use GitLab CI/CD variables or a secrets management solution to store and inject these sensitive values during the deployment process.
* **Clarity:** Document your naming conventions and environment variable usage clearly for other developers on your team.

## Conclusion

Using `dotenv` and the shell integration described above, you can create a robust and efficient workflow for managing environment variables across your projects and environments. This approach improves security, simplifies development, and promotes best practices for configuration management, especially in the context of 12-factor applications. Remember to add your `.env` file to your `.gitignore` to prevent accidentally committing sensitive information to your version control system.
