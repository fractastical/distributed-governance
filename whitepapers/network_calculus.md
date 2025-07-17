
# 📊 Network‑State Viability Model
*(Technical specification – link this file from your calculator for full details.)*

## 1 Purpose
To compare city‑state / network‑state projects on one **risk‑adjusted return** scale that investors can underwrite **and** policymakers can parse.

## 2 Core variables (0 – 1 scores unless noted)

| Group | Symbol | Meaning | Quick proxy ideas |
|-------|--------|---------|-------------------|
| **Boosters** | **L** | Leadership strength (see § 3) | expert survey |
|  | **N** | Economic‑niche clarity / profitability | TAM vs. peers |
|  | **S** | Structural synergy with local population | labor‑skill match |
|  | **C** | Core praxis / generational rootedness (“born‑and‑buried here”) | % residents intending long‑term stay |
|  | **R** | Regulatory‑arbitrage window (years ÷ 5) | 0 = none, 1 ≈ 5 yr |
|  | **F** | **Financial fit** (land + revenue) | § 4 |
| **Drags** | **G** | Gap between economic gains & social benefit | sentiment Δ |
|  | **D** | Wealth‑disparity / demographic friction | Gini rescaled |
|  | **Z** | Legal uncertainty & IP risk | lawsuits / GDP |
|  | **I** | Infrastructure shortfall | cap‑ex gap |
|  | **Q** | Security & rule‑of‑law risk | crime index |
|  | **E** | External legitimacy (banking, visas) | treaty count |
|  | **U** | Ecological / climate risk | LCA score |

*(If a drag has no data, set its weight to 0 rather than guessing.)*

## 3 Leadership decomposition  

### 3.1 Sub‑scores

| Symbol | What it captures |
|--------|------------------|
| `Vs` | Vision‑setting power |
| `Rc` | Recruiting magnetism |
| `Me` | Management execution |
| `Ps` | Population‑synergy crafting |

### 3.2 Aggregate
```
L = (Vs · Rc · Me · Ps)^(1/4)
```
*(Geometric mean: one zero collapses the whole term.)*

## 4 Financial Fit options  

### 4.1 Land‑only (simplest)
*Land IRR capped at 1 = target hurdle (12 % by default).*
```
L_fin = min(1, IRR_land / 0.12)
F     = L_fin
```

### 4.2 Land + IP blend (full model)
```
F = sqrt(L_fin · I_fin)
```
*See § 4 of chat for IP NPV formula. Adjust weights or drop `I_fin` if IP is immaterial.*

## 5 Master viability score  
Multiplicative form (default):
```
V = [L · N · S · C · F · (1 + λR)]
    ----------------------------------------------
    (1+G)(1+D)(1+Z)(1+φI)(1+ψQ)(1+ωE)(1+κU)
```
Default weights: `λ = φ = ψ = ω = κ = 1`  
Interpretation: `V > 1` ⇒ above‑threshold viability.

## 6 Convert **V** to probability (optional)
```
P = 1 / (1 + exp[-k · ln V])
```
Choose `k` so that `V = 1` → `P ≈ 0.50` (k ≈ 5 works for most ranges).

## 7 Additive‑logistic variant (legacy)
```
P_add = σ(αL + βN + γS + δR − ηG − θD − ιZ)
σ(x) = 1/(1+e^{-x})
```
*Weights need empirical fitting; otherwise scores bunch near 1.*

## 8 Worked example  
Inputs:
```
Vs, Rc, Me, Ps = 0.80, 0.60, 0.45, 0.40
N, S, C, R     = 0.70, 0.55, 0.30, 0.20
L_fin          = 2.08      # land IRR 25%
G, D, Z        = 0.25, 0.30, 0.15
I, Q, E, U     = 0         # no data => weight zero
```
1. Leadership  
   `L = (0.80·0.60·0.45·0.40)^(1/4) ≈ 0.55`  
2. Financial fit `F = 2.08`  
3. Viability  
```
V ≈ 1.18  # above threshold
```
4. Probability (`k = 5`)  
```
P ≈ 0.63
```

## 9 How to populate the model
1. **Scrape** news, filings, census data.  
2. **Normalize** variables to 0–1.  
3. **Compute** `L`, `F`, `V` (+ `P`).  
4. **Flag confidence** = populated vars / total vars.

## 10 Reading the outputs

| V range | Meaning |
|---------|---------|
| `< 0.5` | Fragile |
| `0.5–1` | Watchlist |
| `1–2` | Investable |
| `≥ 2` | Breakout |

---

*Fork & tweak: add FX risk, liquidity, or change weights based on your dataset.*
