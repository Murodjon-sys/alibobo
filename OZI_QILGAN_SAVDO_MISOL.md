# O'zi Qilgan Savdo - Real-time Hisoblash

## Qanday Ishlaydi?

Chakana savdo inputiga raqam yozilganda, "O'zi Qilgan Savdo" avtomatik hisoblanadi.

## Misollar

### Misol 1: 10,000,000 so'm
```
Chakana Savdo: 10,000,000
↓ (× 0.5%)
O'zi Qilgan Savdo: 50,000 so'm
```

### Misol 2: 50,000,000 so'm
```
Chakana Savdo: 50,000,000
↓ (× 0.5%)
O'zi Qilgan Savdo: 250,000 so'm
```

### Misol 3: 100,000,000 so'm
```
Chakana Savdo: 100,000,000
↓ (× 0.5%)
O'zi Qilgan Savdo: 500,000 so'm
```

### Misol 4: 200,000,000 so'm
```
Chakana Savdo: 200,000,000
↓ (× 0.5%)
O'zi Qilgan Savdo: 1,000,000 so'm
```

## Real-time Yangilanish

Foydalanuvchi chakana savdo inputiga yozganda:

1. **Raqam kiritiladi**: `10000000`
2. **Format qilinadi**: `10,000,000`
3. **0.5% hisoblanadi**: `10,000,000 × 0.5% = 50,000`
4. **Avtomatik ko'rsatiladi**: "O'zi Qilgan Savdo" inputida `50,000`

## UI Ko'rinishi

```
┌─────────────────────────────────────────┐
│ Chakana Savdo (To'liq foiz)            │
│ ┌─────────────────────────────────────┐ │
│ │ 10,000,000                          │ │ ← Foydalanuvchi yozadi
│ └─────────────────────────────────────┘ │
└─────────────────────────────────────────┘
              ↓ (avtomatik)
┌─────────────────────────────────────────┐
│ O'zi Qilgan Savdo                      │
│ ┌─────────────────────────────────────┐ │
│ │ 50,000                              │ │ ← Avtomatik hisoblanadi
│ └─────────────────────────────────────┘ │
│ 💡 Avtomatik: Chakana savdo × 0.5%     │
└─────────────────────────────────────────┘
```

## Kod

```javascript
onChange={(e) => {
  const cleaned = e.target.value.replace(/[^\d]/g, "");
  if (cleaned === "") {
    setDailySalesInput("");
    setTeamVolumeBonusInput(""); // Tozalash
    return;
  }
  const numValue = parseFloat(cleaned);
  setDailySalesInput(formatNumber(numValue));
  
  // O'zi qilgan savdodan 0.5% ni avtomatik hisoblash
  const personalSalesBonus = (numValue * 0.5) / 100;
  setTeamVolumeBonusInput(formatNumber(Math.round(personalSalesBonus)));
}}
```

## Xususiyatlar

✅ **Real-time**: Har bir belgi yozilganda yangilanadi
✅ **Avtomatik**: Hech qanday tugma bosish kerak emas
✅ **Aniq**: 0.5% formula qo'llaniladi
✅ **Formatlangan**: Vergul bilan ko'rsatiladi (50,000)
✅ **Read-only**: Foydalanuvchi o'zgartira olmaydi
✅ **Tozalash**: Chakana savdo tozalansa, bu ham tozalanadi

## Afzalliklari

1. **Tezkor**: Darhol ko'rsatiladi
2. **Xatosiz**: Avtomatik hisoblash
3. **Tushunarli**: Foydalanuvchi qancha bonus olishini darhol ko'radi
4. **Motivatsiya**: Ko'proq yozsam ko'proq bonus olaman

## Test Qilish

1. Modal oynani oching
2. Chakana savdo inputiga `10000000` yozing
3. "O'zi Qilgan Savdo" inputida `50,000` ko'rinadi ✅
4. Chakana savdoni `50000000` ga o'zgartiring
5. "O'zi Qilgan Savdo" `250,000` ga yangilanadi ✅
