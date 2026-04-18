from pydantic_settings import BaseSettings, SettingsConfigDict
from pydantic import Field

class Settings(BaseSettings):
    # O Pydantic vai procurar essas variáveis no ambiente ou no arquivo .env
    PROJECT_NAME: str = "API Default"
    DEBUG: bool = False
    DATABASE_URL: str = Field(..., alias="DATABASE_URL")

    # Read .env file
    model_config = SettingsConfigDict(
        env_file=".env", 
        env_file_encoding="utf-8",
        extra="ignore" # Ignore extra vars
    )

# Singleton instance of Settings
settings = Settings()
