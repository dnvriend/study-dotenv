from dotenv import load_dotenv
import os

load_dotenv()

print(os.environ["EXAMPLE_APP_DOMAIN"])
