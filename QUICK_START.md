# 🎣 Fishing Harbor - Quick Start Guide

## ✅ App Đã Hoàn Thiện 90%!

---

## 🚀 CHẠY APP NGAY

```bash
cd example && fvm flutter run
```

Hoặc chọn device trong VS Code/Android Studio và nhấn Run!

---

## 🎮 CÁCH CHƠI

### **1. Màn Hình Đầu Tiên**
- App sẽ load save game (hoặc tạo mới)
- Bạn thấy **Home Screen** với:
  - Coins, Energy, Level
  - Daily Missions (real-time progress)
  - Quick Actions

### **2. Đi Câu Cá**
```
Home → Tap "Go Fishing"
  ↓
Choose Ocean Area (River khởi đầu)
  ↓
[Optional] Tap "Cards" → Select 5 Support Cards
  ↓
Fishing Screen
```

### **3. Fishing Minigame**

#### **Phase 1: CAST**
- Power meter chạy 0-100%
- **TAP để release** khi power cao
- Power càng cao = cast càng xa = fish tốt hơn

#### **Phase 2: WAIT**
- Nhìn hook bobbing (🪝)
- Chờ fish bite (2-5 giây)
- Loading indicator...

#### **Phase 3: BITE!**
- Màn hình hiện **"BITE!"** (chữ đỏ, to)
- **TAP NGAY** trong 2 giây
- Miss = fish escape!

#### **Phase 4: REEL**
- Hold finger = pull line (tension tăng)
- Release = rest (tension giảm)
- **Goal**: Giữ tension trong **GREEN ZONE**
- Red zone (top) = fish escape!
- Orange zone (bottom) = too weak
- Green zone (middle) = ✅ GOOD!

#### **Success!**
- Fish caught popup
- Xem: Name, Rarity, Weight, Value
- Auto-saved!

### **4. Sau Khi Câu**
```
Fishing Screen → Tap "Sell Fish"
  ↓
Coins tăng (với building bonuses)
  ↓
Missions update automatically
  ↓
Return Home
```

### **5. Sử Dụng Coins**

#### **Harbor** (Bottom nav: ⚓)
- Upgrade buildings
- Each building = buff khác nhau
- Fish Market = +5% sell price per level

#### **Boat Garage** (Menu → ⛵)
- Buy new boats
- Upgrade boat stats
- Better boat = better fishing

#### **Equipment Shop** (Menu → 🏪)
- Buy better rods, reels, hooks
- Higher power = easier fishing

#### **Support Cards** (Bottom nav: 🃏)
- Select max 5 cards
- Cards give bonuses:
  - Cast distance boost
  - Rare fish chance
  - Double coins
  - Freeze escape

### **6. Daily Missions**
```
Home Screen → See 3 Daily Missions
  ↓
Catch fish → Progress updates real-time
  ↓
Mission complete → Green checkmark
  ↓
Tasks Screen → Tap "Claim" button
  ↓
Get rewards: Coins + XP
```

### **7. Fish Encyclopedia** (Bottom nav: 🐟)
- View all caught fish
- See max weight records
- Collection progress: X/26 (will expand to 180)

---

## 🎯 MISSIONS EXPLAINED

### **Daily Missions** (Reset mỗi ngày)
- Catch 10 Fish
- Catch 2 Rare Fish
- Earn 500 Coins

### **Weekly Missions** (Reset mỗi tuần)
- Visit All Ocean Areas (7/7)
- Catch 50 Fish
- Upgrade Your Boat

### **Achievements** (Permanent)
- First Catch
- Catch 100 Fish
- Catch 1000 Fish
- Earn 1M Coins
- Unlock All Buildings

---

## 🃏 SUPPORT CARDS GUIDE

### **How to Use**
1. Bottom nav → Cards (🃏)
2. Tap card to select (max 5)
3. Selected cards glow
4. Go fishing → Effects auto-apply

### **Card Types**

#### **♠️ Fishing Cards (Blue)**
- Cast Distance +10-20%
- Hook Strength +15-25%
- Reel Speed +20-30%
- Perfect Hook (no fail)
- Instant Catch (skip minigame)

#### **♥️ Recovery Cards (Green)**
- Recover Energy
- Repair Rod
- Repair Boat
- Reduce Fatigue
- Recover Fuel

#### **♦️ Discovery Cards (Gold)**
- Rare Fish Chance +20-30%
- Reveal Fishing Spots
- Treasure Chest Chance
- **Double Coins** (2x money!)

#### **♣️ Utility Cards (Purple)**
- Fast Travel (instant return)
- Auto Reel (60 seconds)
- Extra Storage +50%
- Calm Sea (easy fishing)
- **Freeze** (fish can't escape!)

---

## 🏗️ BUILDING BUFFS

| Building | Buff | Priority |
|----------|------|----------|
| 🏪 Fish Market | +5% sell price/level | ⭐⭐⭐ HIGH |
| ⚓ Dock | +1 boat slot/level | ⭐⭐ Medium |
| 📦 Warehouse | +20 storage/level | ⭐⭐ Medium |
| ❄️ Ice Storage | Fish freshness +10%/level | ⭐ Low |
| 🔧 Repair Shop | Repair cost -10%/level | ⭐ Low |
| 🐠 Aquarium | +50 coins/hour/level | ⭐⭐ Medium |
| 🍽️ Restaurant | +15% XP/level | ⭐⭐⭐ HIGH |

**Recommend**: Upgrade Fish Market & Restaurant first!

---

## 💡 TIPS & TRICKS

### **Early Game**
1. Fish in **River** (easy, low energy)
2. Sell fish → Get coins
3. Upgrade **Fish Market** first
4. Buy better **Rod**
5. Complete daily missions

### **Mid Game**
1. Unlock **Lake** and **Coast**
2. Buy **Fishing Boat** (better storage)
3. Select **Double Coins** card
4. Upgrade **Restaurant** (more XP)
5. Collect 50+ fish species

### **Advanced**
1. Unlock all 7 ocean areas
2. Use **Rare Fish** cards in Deep Sea
3. Complete weekly missions
4. Upgrade **Yacht** (best boat)
5. Chase legendary fish!

### **Fishing Pro Tips**
- **Cast**: Aim for 80-95% power (sweet spot)
- **Reel**: Don't hold too long! Pulse it: hold → release → hold
- **Cards**: Use "Freeze" card on legendary fish
- **Energy**: Rest when below 20

---

## 🐛 TROUBLESHOOTING

### **App crashes on launch?**
```bash
cd example
fvm flutter clean
fvm flutter pub get
fvm flutter run
```

### **Data not saving?**
- Check app permissions
- Should auto-save after each action
- Try: Catch fish → Close app → Reopen
- Data should persist

### **Fishing too hard?**
- Upgrade your rod (Shop)
- Use support cards
- Practice reel timing
- Start in easy areas (River/Lake)

### **Missions not updating?**
- Should update real-time
- Check HomeScreen missions
- Go to Tasks screen → See full progress
- Complete → Tap "Claim"

---

## 📱 APP STRUCTURE

```
🏠 Home
├── View stats
├── Daily missions
└── Quick actions

⚓ Harbor
├── Upgrade buildings
└── Unlock buffs

🐟 Fish Encyclopedia
├── View caught fish
└── Collection progress

🃏 Support Cards
├── Select cards (max 5)
└── View effects

☰ Menu
├── 🗺️ World Map
├── ⛵ Boat Garage
├── 🏪 Equipment Shop
├── 📋 Tasks & Achievements
├── 👤 Profile
└── ⚙️ Settings
```

---

## ✅ WHAT TO TEST

### **Core Features**
- [ ] Launch app (load save)
- [ ] Go fishing (minigames work)
- [ ] Cast with power meter
- [ ] Reel with tension control
- [ ] Catch multiple fish
- [ ] Sell fish (coins increase)
- [ ] Buy equipment (coins decrease)
- [ ] Upgrade building
- [ ] Complete mission → Claim reward
- [ ] Close & reopen app (data persists)

### **Advanced Features**
- [ ] Select 5 support cards
- [ ] Fish with cards (see effects)
- [ ] Try different ocean areas
- [ ] Check fish encyclopedia
- [ ] View profile stats
- [ ] Mission progress updates
- [ ] XP and level up
- [ ] Boat purchase & equip

---

## 🎮 RECOMMENDED TEST FLOW

```
1. Launch → New game starts
2. Home → Check daily missions (should be 0/X progress)
3. Go Fishing → River area
4. Cast (practice power meter)
5. Catch 3-5 fish
6. Return → Sell fish
7. Check missions → Progress updated!
8. Use coins → Upgrade Fish Market
9. Go fishing again → Notice increased value
10. Catch 10 fish total → Mission complete
11. Tasks screen → Claim reward
12. Close app completely
13. Reopen → Data should be saved!
```

---

## 🎉 ENJOY!

Bạn đang chơi **Fishing Harbor** - một simulation game hoàn chỉnh với:
- ✅ Skill-based minigames
- ✅ Progression system
- ✅ Daily missions
- ✅ Card strategy
- ✅ Building management
- ✅ Fish collection

**Have fun fishing! 🎣**

---

## 🐞 KNOWN ISSUES

1. **Equipment durability** không giảm (planned for 1.1)
2. **Active card usage** chưa có UI button (planned)
3. **Sound effects** chưa có (planned)
4. **Weather effects** chưa implement (visual only)

None of these affect core gameplay! 🎮

---

## 💬 FEEDBACK

Nếu tìm thấy bugs hoặc có suggestions:
1. Test thoroughly
2. Document the issue
3. Check if it's in Known Issues
4. Report with steps to reproduce

---

**Version**: 1.0.0 (90% Complete)
**Last Updated**: Today
**Status**: ✅ Fully Playable!
