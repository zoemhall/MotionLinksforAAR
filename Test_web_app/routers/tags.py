from fastapi import APIRouter
from db import queries

router = APIRouter()


@router.get("/frequent")
async def get_frequent_tags(limit: int = 10):
    """Most-frequently-used tags across all sessions, with usage counts."""
    return await queries.frequent_tags(limit=limit)
