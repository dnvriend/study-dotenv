from dotenv import load_dotenv
import os

load_dotenv('.env-dev', override=False)

print(os.environ["EXAMPLE_APP_DOMAIN"])
