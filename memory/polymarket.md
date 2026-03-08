# Polymarket Trading Guide

## What You Need
1. **Web3 Wallet** — MetaMask or Coinbase Wallet
2. **USDC** — Stablecoin for trading (pegged to $1)
3. **MATIC** — For Polygon network fees (~$5 covers 100+ trades)

## Steps to Set Up
1. Install MetaMask at metamask.io
2. Add Polygon network:
   - Network Name: Polygon Mainnet
   - RPC URL: https://polygon-rpc.com
   - Chain ID: 137
   - Symbol: MATIC
3. Get USDC — Buy on Coinbase or exchange, then send to your MetaMask address
4. Connect to polymarket.com — Click "Connect Wallet"

## How Trading Works
- Each market has YES/NO shares priced $0-$1
- Price = implied probability (e.g., $0.75 = 75% chance)
- Buy YES if you think it'll happen, NO if not
- Can sell anytime before resolution to lock in profits/losses
- Wins pay $1 per share

## Quick Tips
- Start small — prediction markets are volatile
- Look for edges where your knowledge beats the market
- Check the "volume" — higher = more liquid markets

## Next Steps (What I Can Help With)
1. ✅ Script: `~/workspace/scripts/polymarket_analyzer.py` - analyzes/finds markets
2. ✅ USDC Deposit instructions (below)
3. ✅ Current hot markets (below)

---

## 📍 How to Deposit USDC to Polymarket

### Option 1: Buy directly on Polymarket (Easiest)
1. Go to polymarket.com and connect your wallet
2. Click "Deposit" or "Buy USDC"
3. Use credit/debit card to buy USDC directly
4. Done! Funds go to your connected wallet

### Option 2: From Coinbase
1. Open Coinbase → Portfolio
2. Click "Send/Receive" → "Send"
3. Select USDC
4. Enter your MetaMask address (click "Receive" in MetaMask to copy)
5. Select "Polygon" network (important!)
6. Send — typically arrives in seconds

### Option 3: From any exchange
1. Get your MetaMask Polygon address
2. Withdraw USDC to that address
3. Select Polygon (MATIC) network
4. Wait ~30 sec for confirmation

### Get your MetaMask address:
1. Open MetaMask → click top to copy address
2. Make sure you're on Polygon network (check the dropdown)

---

## 🔥 Trending Markets (Feb 22, 2026)

### Geopolitics
- **US strikes Iran by March 7?** — 37% YES ($366M volume)
- **US anti-cartel ground operation in Mexico by March 31?** — 22% YES ($580K)
- **Khamenei out as Iran Supreme Leader by March 31?** — 22% YES ($16M)
- **US confirms aliens exist before 2027?** — 14% YES ($6M)

### Politics
- **SOTU: Trump says "America" 25+ times?** — 93% YES ($436K)
- **Court forces Trump to refund tariffs?** — 18% YES ($145K)
- **Texas Dem Senate Primary — James Talarico wins?** — 78% YES

### Crypto
- **BTC 5-min up or down** — Live, $16M volume

### Sports
- **Celtics vs Lakers** — 66% Celtics ($4M)

### Weather
- **NYC snow this weekend (12-14")?** — 25% YES ($217K)
- **NYC snow (14-16")?** — 26% YES

---

## 🤖 Market Analyzer Script

Run: `python3 ~/workspace/scripts/polymarket_analyzer.py`

Script fetches markets by topic (politics, crypto, sports, tech).
