# Experiment Design — Reducing Bad Reviews From Late Deliveries

## Background
Analysis found that late orders (delivered after the promised date) average a 2.57 review
score versus 4.29 for on-time orders, and are ~6x more likely to get a 1–2 star review.
Reviews appear to be driven by **actual delivery time versus the promised estimate**, not
delivery speed in absolute terms. Since 96.9% of customers never buy again, a bad first
delivery experience is effectively a lost customer.

## Idea
"Under-promise, over-deliver." If we set a slightly more conservative (padded) delivery
estimate at checkout, fewer orders will arrive *later than promised*, which should raise
review scores. The risk is that a slower-looking promise scares off buyers, so we must
watch conversion as a guardrail.

## Hypothesis
Showing a padded delivery estimate (current estimate + a buffer) will **reduce the
low-review rate** (share of 1–2 star reviews) versus the current estimate, without a
meaningful drop in checkout conversion.

## Design

**Type:** Randomized, controlled A/B test.

**Unit of randomization:** the customer (session). Each customer is assigned once and
stays in the same group so their experience is consistent.

**Groups:**
- **Control (A):** current delivery-date estimate shown at checkout.
- **Treatment (B):** padded estimate (current estimate + buffer, e.g. +3 days).

**Split:** 50/50.

## Metrics
- **Primary:** low-review rate (% of delivered orders receiving a 1 or 2 star review).
  Lower is better.
- **Secondary:** average review score; share of orders that arrive later than promised.
- **Guardrail (must not harm):** checkout conversion rate. If a padded promise tanks
  conversion, the test fails even if reviews improve.

## Minimum detectable effect (MDE)
We want to detect at least a **1.5 percentage point** absolute drop in the low-review rate
(baseline ≈ 13% → 11.5%). Smaller than that is not worth the operational change.

## Sample size (rough)
For a two-proportion test at 95% confidence (alpha = 0.05) and 80% power, a common
rule-of-thumb is:

    n per group ≈ 16 × p × (1 − p) / (MDE)²
                ≈ 16 × 0.13 × 0.87 / (0.015)²
                ≈ 8,000 orders per group  (~16,000 total)

(A proper power calculator should confirm this before launch.) Given ~100k orders over the
period, 16k is very reachable, so the constraint is **calendar time**, not volume.

## Duration
Run for at least **2–3 full weeks** to cover weekly seasonality and let orders actually be
delivered and reviewed (delivery + review lag). Do not stop early the first time it looks
significant ("peeking" inflates false positives). Decide the end date up front.

## Analysis plan
1. Confirm the randomization is balanced (group sizes, pre-period metrics similar).
2. Compare low-review rate between groups with a two-proportion z-test; report the effect
   size and 95% confidence interval, not just the p-value.
3. Check the guardrail (conversion) for any significant drop.
4. Segment-check (e.g. by region/category) to make sure the effect is not driven by one
   pocket, but treat segment results as exploratory.

## Decision rule
- **Ship** if the low-review rate drops by ≥ 1.5 pts, it is statistically significant, and
  conversion is not significantly harmed.
- **Do not ship** if reviews do not improve, or if conversion drops meaningfully.
- **Iterate** (try a different buffer size) if reviews improve but conversion is hurt.

## Threats to validity
- **Novelty / seasonality:** running across full weeks and a decision date guards against this.
- **Delivery + review lag:** an order placed late in the window may not be reviewed before
  analysis; only count orders with enough time to be delivered and reviewed.
- **Correlation vs cause (from the original finding):** this experiment is precisely how we
  move from "late orders correlate with bad reviews" to a causal, actionable answer.
