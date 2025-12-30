# Salary Management System - Complete Documentation

## Project Overview
A comprehensive salary management system for managing employees, sales, bonuses, and monthly plans across multiple branches.

## Key Features

### 1. Employee Management
- Add/Edit/Delete employees
- Multiple positions (dynamic)
- Percentage-based salary calculation
- Daily task tracking

### 2. Sales Tracking
- **Retail Sales** (Full percentage)
- **Wholesale Sales** (Half percentage)
- Daily sales input per seller
- Automatic total sales calculation

### 3. Bonus System
Multiple bonus types:
- **Fixed Bonus** (Standart Oylik): Regular monthly bonus
- **Personal Bonus** (Shaxsiy Bonus): Individual achievement bonus
- **Team Volume Bonus** (Jamoaviy Abyom): Team performance bonus
- **Sales Share Bonus** (0.5%): Automatic calculation - (Total Sales × 0.5%) ÷ Number of Sellers
- **Plan Bonus** (1,000,000): Awarded when monthly plan completed

### 4. Monthly Plan System
- **Default Plan**: 500,000,000 so'm (retail sales only)
- **Bonus**: 1,000,000 so'm when plan completed
- **Auto-tracking**: Daily retail sales accumulate
- **Visual Progress**: Progress bars, completion status
- **Branch Selection**: Select branch first, then view sellers

### 5. History & Reports
- Save daily sales to history
- Monthly reports by employee
- Penalty tracking
- Reset data after saving to history

### 6. Multi-Branch Support
- Asosiy Sklad (Main Warehouse)
- G'ijduvon Filial
- Navoiy Filial
- Branch-specific managers with limited access

### 7. Dark Mode
- Full dark mode support
- Smooth transitions
- Optimized for readability

## Technical Stack

### Frontend
- **React** with TypeScript
- **Vite** for build tool
- **Tailwind CSS** for styling
- Responsive design (mobile-friendly)

### Backend
- **Node.js** with Express
- **MongoDB** for database
- RESTful API architecture

### Database Schema

#### Employee
```javascript
{
  name: String,
  position: String,
  percentage: Number,
  branchId: ObjectId,
  dailyTasks: Object,
  dailySales: Number,
  wholesaleSales: Number,
  lastSalesDate: String,
  fixedBonus: Number,
  personalBonus: Number,
  teamVolumeBonus: Number,
  salesShareBonus: Number,
  monthlyPlan: Number (default: 500000000),
  monthlyRetailSales: Number,
  planBonus: Number
}
```

#### Branch
```javascript
{
  name: String,
  totalSales: Number,
  retailSales: Number,
  wholesaleSales: Number,
  penaltyFund: Number
}
```

#### DailySalesHistory
```javascript
{
  date: String,
  branchId: ObjectId,
  totalSales: Number,
  retailSales: Number,
  wholesaleSales: Number,
  penaltyAmount: Number,
  employees: [{
    employeeId: ObjectId,
    name: String,
    position: String,
    percentage: Number,
    dailySales: Number,
    wholesaleSales: Number,
    dailyTasks: Object,
    salary: Number,
    penaltyAmount: Number,
    fixedBonus: Number,
    personalBonus: Number,
    teamVolumeBonus: Number,
    salesShareBonus: Number,
    planBonus: Number,
    monthlyRetailSales: Number
  }]
}
```

## Salary Calculation Formula

### For Sellers (Sotuvchi)
```
Base Salary = (Retail Sales × Percentage) + (Wholesale Sales × Percentage ÷ 2)

Task Penalty = Incomplete Tasks × 10%
Task Adjusted Salary = Base Salary × (100% - Task Penalty) / 100

Total Salary = Task Adjusted Salary + 
               Fixed Bonus + 
               Personal Bonus + 
               Team Volume Bonus + 
               Sales Share Bonus + 
               Plan Bonus
```

### For Other Employees
```
Base Salary = (Branch Retail Sales × Percentage) + (Branch Wholesale Sales × Percentage ÷ 2)

Task Penalty = Incomplete Tasks × 10%
Task Adjusted Salary = Base Salary × (100% - Task Penalty) / 100

Total Salary = Task Adjusted Salary + 
               Fixed Bonus + 
               Personal Bonus + 
               Team Volume Bonus
```

## Sales Share Bonus Calculation
```
Retail Sales Only × 0.5% = Total Share Bonus
Total Share Bonus ÷ Number of Sellers = Bonus Per Seller

Example:
80,000,000 (chakana) × 0.5% = 400,000
400,000 ÷ 8 sellers = 50,000 per seller

Note: Only RETAIL sales are used, NOT wholesale sales
```

## Monthly Plan Flow
1. Seller enters daily retail sales
2. System accumulates to `monthlyRetailSales`
3. Progress shown in "Oylik Plan" page
4. At month end, when saving to history:
   - Check: `monthlyRetailSales >= 500,000,000`?
   - If yes: `planBonus = 1,000,000`
   - Save to history
   - Reset `monthlyRetailSales = 0`
   - Bonus added to next month's salary

## User Roles

### Admin
- Full access to all features
- Can add/edit/delete employees
- Can manage all branches
- Can save to history

### Manager (View Only)
- Can view all data
- Cannot modify anything

### Branch Managers
- **G'ijduvon Manager**: Access only to G'ijduvon branch
- **Navoiy Manager**: Access only to Navoiy branch
- Can view and manage their branch only

## API Endpoints

### Authentication
- `POST /api/login` - User login

### Branches
- `GET /api/branches` - Get all branches with employees
- `POST /api/branches` - Create new branch
- `PUT /api/branches/:id/sales` - Update branch sales

### Employees
- `POST /api/employees` - Add new employee
- `PUT /api/employees/:id` - Update employee
- `DELETE /api/employees/:id` - Delete employee
- `PUT /api/employees/:id/tasks` - Update employee tasks

### History
- `POST /api/history/save-daily` - Save daily sales to history
- `GET /api/history/:branchId` - Get history by branch
- `DELETE /api/history/:id` - Delete history record

### Task Templates
- `GET /api/task-templates` - Get task templates
- `POST /api/task-templates` - Add task template
- `PUT /api/task-templates/:id` - Update task template
- `DELETE /api/task-templates/:id` - Delete task template

### Positions
- `GET /api/positions` - Get all positions
- `POST /api/positions` - Add new position
- `DELETE /api/positions/:id` - Delete position

## Environment Variables
```
MONGODB_URI=mongodb://...
ADMIN_LOGIN=admin
ADMIN_PASSWORD=...
MANAGER_LOGIN=manager
MANAGER_PASSWORD=...
GIJDUVON_MANAGER_LOGIN=...
GIJDUVON_MANAGER_PASSWORD=...
NAVOI_MANAGER_LOGIN=...
NAVOI_MANAGER_PASSWORD=...
```

## Deployment

### VPS Setup
1. Install Node.js and MongoDB
2. Clone repository
3. Install dependencies: `npm install`
4. Build frontend: `npm run build`
5. Start server: `npm start`

### Nginx Configuration
See `nginx-salary.conf` for reverse proxy setup

### Docker Support
See `.dockerignore` for Docker configuration

## UI Components

### Main Dashboard
- 3 cards: Total Sales, Retail Sales, Wholesale Sales
- Employee list with actions
- Dark mode toggle

### Modals
- **Add Employee**: Name, position, percentage
- **Daily Sales**: Retail, wholesale, all bonuses
- **Tasks**: Daily task checklist
- **Monthly Plan**: Progress tracking per seller

### Sidebar Navigation
- Branches (Filiallar)
- History (Tarix)
- Penalties (Jarimalar)
- Daily Tasks (Kunlik Ishlar)
- Reports (Hisobotlar)
- Monthly Plan (Oylik Plan)

## Best Practices

### Data Flow
1. Enter daily sales → Accumulates monthly sales
2. Complete daily tasks → Affects salary calculation
3. Save to history → Resets daily data, preserves history
4. Monthly plan tracking → Automatic bonus award

### Performance
- Optimistic UI updates (instant feedback)
- Background API calls
- Efficient state management
- Minimal re-renders

### Security
- Role-based access control
- Environment variables for credentials
- Input validation
- MongoDB injection prevention

## Future Enhancements
- [ ] Export to Excel
- [ ] SMS notifications
- [ ] Mobile app
- [ ] Advanced analytics
- [ ] Multi-currency support
- [ ] Automated backups

## Support
For issues or questions, contact the development team.

---

**Last Updated**: December 2024
**Version**: 1.0.0
