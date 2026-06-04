from __future__ import annotations
from pydantic import BaseModel, Field
from typing import Optional


# --- Participants ---

class ParticipantCreate(BaseModel):
    participant_id: str = Field(pattern=r"^\d{2}$")
    shoe_size: str = ""
    insole_size: Optional[str] = Field(default=None, pattern=r"^[SML]$")
    age: Optional[int] = None
    # Gender is required. Dropdown values are 'Male' / 'Female' /
    # 'Prefer not to say', or any free text supplied for 'Other'.
    gender: str = Field(min_length=1)
    injuries: str = ""    # e.g. "none" or "right leg shorter by 1cm"


# --- Test types ---

class TestTypeCreate(BaseModel):
    name: str = Field(min_length=1, max_length=128)
    description: str = ""
    has_calibration: int = Field(default=1, ge=0, le=1)
    has_calibration_files: int = Field(default=0, ge=0, le=1)
    has_audio_familiarisation: int = Field(default=1, ge=0, le=1)
    has_condition_1: int = Field(default=1, ge=0, le=1)
    has_condition_2: int = Field(default=1, ge=0, le=1)
    has_imu_dump: int = Field(default=1, ge=0, le=1)
    has_pressure_merge: int = Field(default=1, ge=0, le=1)
    has_consciousness_check: int = Field(default=1, ge=0, le=1)
    has_overall_ratings: int = Field(default=1, ge=0, le=1)
    target_participants: int = Field(default=0, ge=0)


class TestTypeUpdate(TestTypeCreate):
    pass


# --- Sessions ---

class SessionUpdate(BaseModel):
    session_date: Optional[str] = None
    condition_order: Optional[str] = Field(default=None, pattern=r"^(A-first|B-first)$")
    tempo_direction: Optional[str] = Field(default=None, pattern=r"^(speeding_up|slowing_down)$")
    weight_direction: Optional[str] = Field(default=None, pattern=r"^(increasing|decreasing)$")
    notes_setup: str = ""
    notes_use: str = ""
    notes_data: str = ""
    notes: str = ""
    pressure_raw_path: Optional[str] = None
    cal_file_1_path: Optional[str] = None
    cal_file_2_path: Optional[str] = None
    cal_file_3_path: Optional[str] = None


class SessionCreate(BaseModel):
    participant_id: str = Field(pattern=r"^\d{2}$")
    test_type_id: int
    # Condition order + directions are only required when the test type has
    # condition stages. Validate at the API layer (router) rather than via
    # Pydantic so the rules can vary per test type.
    condition_order: Optional[str] = Field(default=None, pattern=r"^(A-first|B-first)$")
    tempo_direction: Optional[str] = Field(default=None, pattern=r"^(speeding_up|slowing_down)$")
    weight_direction: Optional[str] = Field(default=None, pattern=r"^(increasing|decreasing)$")
    notes_setup: str = ""
    notes_use: str = ""
    notes_data: str = ""
    notes: str = ""


# --- Stage events (transitions during the live view) ---

class StageEventCreate(BaseModel):
    stage_id: str = Field(min_length=1, max_length=64)
    device_ms: Optional[float] = None


# --- Questionnaire ---
# The questionnaire is split into:
#   - Consciousness check: ONE submission per session covering all four stages.
#   - Overall ratings (agency, UEQ-S pragmatic, ARI immersion): once per session.
# A session is marked complete when both rows exist.

# Allowed guess values:
#   For Condition A (tempo): 'speeding_up' | 'slowing_down' | 'no_change'
#   For Condition B (weight): 'lighter'   | 'heavier'      | 'no_change'
_GUESS_PATTERN = r"^(speeding_up|slowing_down|no_change|lighter|heavier)$"
_TEMPO_GUESS_PATTERN = r"^(speeding_up|slowing_down|no_change)$"
_WEIGHT_GUESS_PATTERN = r"^(lighter|heavier|no_change)$"


class ConsciousnessSubmit(BaseModel):
    # Stage 1
    post_calibration_noticed: int = Field(ge=0, le=1)
    post_calibration_text: str = ""
    # Stage 2 — first condition
    cond1_noticed: int = Field(ge=0, le=1)
    cond1_guess: Optional[str] = Field(default=None, pattern=_GUESS_PATTERN)
    cond1_text: str = ""
    # Stage 3 — second condition
    cond2_noticed: int = Field(ge=0, le=1)
    cond2_guess: Optional[str] = Field(default=None, pattern=_GUESS_PATTERN)
    cond2_text: str = ""
    # Stage 4 — post-session debrief
    post_session_noticed: int = Field(ge=0, le=1)
    post_session_text: str = ""
    post_session_tempo_guess: Optional[str] = Field(default=None, pattern=_TEMPO_GUESS_PATTERN)
    post_session_weight_guess: Optional[str] = Field(default=None, pattern=_WEIGHT_GUESS_PATTERN)


class RatingsSubmit(BaseModel):
    agency_q1: int = Field(ge=0, le=10)
    agency_q2: int = Field(ge=0, le=10)
    agency_q3: int = Field(ge=0, le=10)
    # UEQ-S: 4 pragmatic items only (hedonic items removed from the study).
    ueqs_items: list[int] = Field(min_length=4, max_length=4)
    ari_items: list[int]


# --- Phase command ---

class PhaseCommand(BaseModel):
    phase: int = Field(ge=0, le=9)


# --- Notes update ---

class NotesUpdate(BaseModel):
    notes_setup: str = ""
    notes_use: str = ""
    notes_data: str = ""
    notes: str = ""


# --- Import ---

class ImportSessionCreate(BaseModel):
    participant_id: str = Field(pattern=r"^\d{2}$")
    shoe_size: str = ""
    insole_size: Optional[str] = Field(default=None, pattern=r"^[SML]$")
    age: Optional[int] = None
    gender: str = Field(min_length=1)
    injuries: str = ""
    test_type_id: int
    notes_setup: str = ""
    notes_data: str = ""
    notes: str = ""
    main_file: str = Field(min_length=1)
    cal_file_1: Optional[str] = None
    cal_file_2: Optional[str] = None
    cal_file_3: Optional[str] = None
    session_date: Optional[str] = None   # ISO datetime, e.g. "2025-03-14T10:30"
    auto_complete: bool = False


# --- Tags ---

class TagCreate(BaseModel):
    tag: str = Field(min_length=1, max_length=64)
    stage: Optional[str] = None
    note: str = ""
    device_ms: Optional[float] = None
