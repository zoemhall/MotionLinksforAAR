# Gait Study Outcomes — Column Codebook

## Identifiers
| Column | Description |
|--------|-------------|
| participant_id | Two-digit participant ID (e.g. 03, 39) |
| session_id | Internal database session ID |
| condition_order | A-first = tempo presented first; B-first = weight presented first |
| tempo_presentation_order | 1st or 2nd (derived from condition_order) |
| weight_presentation_order | 1st or 2nd (derived from condition_order) |

## Experimental design
| Column | Description |
|--------|-------------|
| tempo_direction | speeding_up or slowing_down |
| weight_direction | increasing (heavier) or decreasing (lighter) |

## Influence outcomes
| Column | Values | Description |
|--------|--------|-------------|
| tempo_outcome | influenced_intended, influenced_transient, no_effect | Tempo gait influence classification |
| weight_outcome | influenced_intended, influenced_transient, influenced_opposite, no_effect | Weight gait influence classification |
| tempo_onset | early, gradual, none | When tempo effect began |
| weight_onset | early, gradual, none | When weight effect began |

## Tempo gait metrics
| Column | Units | Description |
|--------|-------|-------------|
| tempo_effect_pct | % | Cadence change relative to baseline in active phase. Positive = faster, negative = slower. For influenced_transient this is the peak (signed), not the final-third mean |
| tempo_audio_change_pct | % | Audio BPM change in the last third of the active manipulation phase |
| tempo_coupling_ratio | — | tempo_effect_pct / tempo_audio_change_pct. Strength of cadence tracking relative to audio change |
| tempo_entrainment_r | −1 to +1 | Pearson r between cadence time series and audio BPM time series during condition |

## Weight gait metrics
| Column | Units | Description |
|--------|-------|-------------|
| weight_effect_pct_stance | % | Stance-phase duration change relative to baseline. Positive = longer stance (heavier feel) |
| weight_effect_pct_imu | % | IMU-derived bilateral heel force change. Positive = more force |
| weight_effect_pct_peak | % | Peak weight effect (stance-based) |

## Subjective measures
| Column | Scale | Description |
|--------|-------|-------------|
| agency_q1 | 0–10 | "The sound influenced my movement" |
| agency_q2 | 0–10 | "My movement influenced the sound" |
| agency_q3 | 0–10 | "I felt in control of the interaction" |
| agency_aggregate | 0–10 | Mean of q1, q2, q3 |
| ueqs_pragmatic | −3 to +3 | User Experience Questionnaire Short — pragmatic quality subscale |
| ari_immersion | 0–7 | Absorption and Resonance Index — immersion subscale |

## Notes
- N=23 participants with at least one reviewed condition
- P30 (session 68): only tempo was reviewed; weight_outcome is blank
- All effect percentages use the active manipulation phase only (drift-out excluded)
- Influence classification threshold: 1.0 SD sustained (intended), 0.7 SD peak with 8 s rolling window (transient)
