from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models.user import User
from app.schemas.user import UserCreate
from app.core.security import get_password_hash

class UserService:
    @staticmethod
    async def get_by_email(db: AsyncSession, email: str):
        query = select(User).where(User.email == email)
        result = await db.execute(query)
        return result.scalars().first()

    @staticmethod
    async def create(db: AsyncSession, user_in: UserCreate):
        db_user = User(
            email=user_in.email,
            hashed_password=get_password_hash(user_in.password)
        )
        db.add(db_user)
        await db.commit()
        await db.refresh(db_user)
        return db_user
