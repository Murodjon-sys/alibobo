# Bonus Tizimi Yangilanishi

## O'zgartirilgan Bonus: "Jamoaviy Abyom Bonusi" → "O'zi Qilgan Savdodan (0.5%)"

### Eski Tizim:
- **Nomi**: O'zi qilgan savdodan
- **Turi**: Qo'lda kiritish
- **Maqsad**: Jamoa natijasi uchun mukofot

### Yangi Tizim:
- **Nomi**: O'zi Qilgan Savdodan (0.5%)
- **Turi**: Avtomatik hisoblash
- **Formula**: `Sotuvchining chakana savdosi × 0.5%`
- **Maqsad**: Har bir sotuvchining o'z savdosidan bonus

## Qanday Ishlaydi?

### Misol 1:
Sotuvchi bugun **10,000,000 so'm** chakana savdo qildi:
```
O'zi qilgan savdodan bonus = 10,000,000 × 0.5% = 50,000 so'm
```

### Misol 2:
Sotuvchi bugun **50,000,000 so'm** chakana savdo qildi:
```
O'zi qilgan savdodan bonus = 50,000,000 × 0.5% = 250,000 so'm
```

### Misol 3:
Sotuvchi bugun **100,000,000 so'm** chakana savdo qildi:
```
O'zi qilgan savdodan bonus = 100,000,000 × 0.5% = 500,000 so'm
```

## Texnik Tafsilotlar

### Avtomatik Hisoblash
Kunlik savdo modal oynasi ochilganda:
```javascript
const employeeRetailSales = employee.dailySales || 0;
const personalSalesBonus = (employeeRetailSales * 0.5) / 100;
```

### Input Xususiyatlari
- **Read-only**: Foydalanuvchi o'zgartira olmaydi
- **Avtomatik**: Sotuvchining chakana savdosiga qarab avtomatik hisoblanadi
- **Rang**: Teal (ko'k-yashil) - `bg-teal-50`, `border-teal-300`
- **Icon**: Ko'k-yashil nuqta

### UI Ko'rinishi
```
┌─────────────────────────────────────────┐
│ O'zi Qilgan Savdodan (0.5%)            │
│ ┌─────────────────────────────────────┐ │
│ │ 50,000                              │ │ (read-only)
│ └─────────────────────────────────────┘ │
│ 💡 Avtomatik: O'z chakana savdosi × 0.5%│
└─────────────────────────────────────────┘
```

## Farqi

| Xususiyat | Eski (Jamoaviy Abyom) | Yangi (O'z Savdodan) |
|-----------|----------------------|---------------------|
| Kiritish | Qo'lda | Avtomatik |
| Asosi | Jamoa natijasi | O'z savdosi |
| Foiz | - | 0.5% |
| Savdo turi | - | Faqat chakana |
| O'zgartirish | Ha | Yo'q (read-only) |

## Bonus Tizimi Umumiy Ko'rinishi

Endi sotuvchilar uchun 5 xil bonus mavjud:

1. **Standart Oylik** - Qo'lda kiritish
2. **Shaxsiy Bonus** - Qo'lda kiritish
3. **O'zi Qilgan Savdodan (0.5%)** - ✅ Avtomatik (yangi)
4. **Jami Savdodan Ulush (0.5%)** - Avtomatik
5. **Oylik Plan Bonusi** - Avtomatik (1,000,000 so'm)

## Oylik Hisoblash

```
JAMI OYLIK = 
  (Kunlik savdo × Foiz) +
  Standart Oylik +
  Shaxsiy Bonus +
  O'zi Qilgan Savdodan (0.5%) +
  Jami Savdodan Ulush (0.5%) +
  Oylik Plan Bonusi
```

## Afzalliklari

✅ **Adolatli**: Har bir sotuvchi o'z savdosiga qarab bonus oladi
✅ **Shaffof**: Hisoblash formulasi aniq
✅ **Avtomatik**: Xato ehtimoli yo'q
✅ **Motivatsiya**: Ko'proq savdo qilgan ko'proq bonus oladi
✅ **Oddiy**: Foydalanuvchi uchun tushunarli

## Misollar

### Sotuvchi A (Kuchli):
- Kunlik chakana savdo: 80,000,000 so'm
- O'z savdodan bonus: 400,000 so'm ✅

### Sotuvchi B (O'rtacha):
- Kunlik chakana savdo: 30,000,000 so'm
- O'z savdodan bonus: 150,000 so'm ✅

### Sotuvchi C (Yangi):
- Kunlik chakana savdo: 10,000,000 so'm
- O'z savdodan bonus: 50,000 so'm ✅

Har bir sotuvchi o'z mehnatiga yarasha mukofotlanadi! 🎉
