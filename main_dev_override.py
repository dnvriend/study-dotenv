from dotenv import load_dotenv
import os

load_dotenv('.env-dev', override=True)

print(os.environ["EXAMPLE_APP_DOMAIN"])
