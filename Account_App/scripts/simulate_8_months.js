import { createClient } from '@supabase/supabase-js';

const SUPABASE_URL = "https://kglawcgwryxrjvorxmbk.supabase.co";
const SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtnbGF3Y2d3cnl4cmp2b3J4bWJrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI0ODg5ODQsImV4cCI6MjA4ODA2NDk4NH0.qMNhMguri25hY6fFmbuDd9eEPMOXbl27ERbhnYe1oOk";

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

const email = `demo_${Date.now()}@finapp.com`;
const password = 'securepassword123';

async function generateData() {
    console.log(`--> Creating new user: ${email}...`);
    const { data: authData, error: authError } = await supabase.auth.signUp({
        email, password
    });

    if (authError || !authData.user) {
        console.error("Signup failed:", authError?.message);
        return;
    }

    const userId = authData.user.id;
    console.log(`--> Logged in. User ID: ${userId}`);

    console.log("--> Clearing old data...");
    await supabase.from('transactions').delete().eq('user_id', userId);
    await supabase.from('recurring_transactions').delete().eq('user_id', userId);
    await supabase.from('goals').delete().eq('user_id', userId);
    await supabase.from('user_wealth').delete().eq('user_id', userId);

    const now = new Date();
    const months = 8;
    let transactionsBatch = [];

    // Helper functions
    const getRandomAmount = (min, max) => (Math.random() * (max - min) + min).toFixed(2);
    const getDaysInMonth = (year, month) => new Date(year, month + 1, 0).getDate();

    // 1. RECURRING DATA
    console.log("--> Setting up Recurring Transactions...");
    await supabase.from('recurring_transactions').insert([
        { user_id: userId, type: 'income', amount: 3200, category: 'Income - Salario fijo', frequency: 'monthly', description: 'Nómina Mensual', next_date: now.toISOString(), start_date: new Date(now.getFullYear(), now.getMonth() - months, 1).toISOString() },
        { user_id: userId, type: 'expense', amount: 950, category: 'Housing - Alquiler', frequency: 'monthly', description: 'Alquiler', next_date: now.toISOString(), start_date: new Date(now.getFullYear(), now.getMonth() - months, 2).toISOString() },
        { user_id: userId, type: 'expense', amount: 45, category: 'Healthcare - Gimnasio', frequency: 'monthly', description: 'Gym Centro', next_date: now.toISOString(), start_date: new Date(now.getFullYear(), now.getMonth() - months, 4).toISOString() },
        { user_id: userId, type: 'expense', amount: 15.99, category: 'Entertainment - Suscripciones digitales', frequency: 'monthly', description: 'Netflix Premium', next_date: now.toISOString(), start_date: new Date(now.getFullYear(), now.getMonth() - months, 15).toISOString() },
    ]);

    // 2. BACKFILL 8 MONTHS DIRECT TRANSACTIONS
    console.log(`--> Backfilling ${months} months of historical transactions...`);

    for (let i = months; i >= 0; i--) {
        const targetDate = new Date(now.getFullYear(), now.getMonth() - i, 1);
        const year = targetDate.getFullYear();
        const month = targetDate.getMonth();
        const daysInMonth = getDaysInMonth(year, month);

        // Fixed Monthly
        transactionsBatch.push({
            user_id: userId, type: 'income', amount: 3200, category: 'Income - Salario fijo', description: 'Nómina', date: new Date(year, month, 1).toISOString(), created_at: new Date(year, month, 1, 9, 0).toISOString()
        });
        transactionsBatch.push({
            user_id: userId, type: 'expense', amount: 950, category: 'Housing - Alquiler', description: 'Alquiler', date: new Date(year, month, 2).toISOString(), created_at: new Date(year, month, 2, 10, 0).toISOString()
        });
        transactionsBatch.push({
            user_id: userId, type: 'expense', amount: 120, category: 'Utilities - Electricidad', description: 'Suministros (Luz y Gas)', date: new Date(year, month, Math.floor(Math.random() * 5) + 3).toISOString(), created_at: new Date(year, month, 5, 11, 0).toISOString()
        });
        transactionsBatch.push({
            user_id: userId, type: 'expense', amount: 60.99, category: 'Utilities - Internet', description: 'Fibra + Móvil', date: new Date(year, month, 15).toISOString(), created_at: new Date(year, month, 15, 12, 0).toISOString()
        });

        // Dynamic Variable Expenses
        // Groceries (approx 5 times a month)
        for (let j = 0; j < 5; j++) {
            const day = Math.floor(Math.random() * 25) + 1;
            const amounts = [60, 85, 120, 45, 110];
            const descriptions = ['Mercadona', 'Carrefour Express', 'Lidl', 'Consum', 'Aldi'];
            transactionsBatch.push({
                user_id: userId, type: 'expense', amount: getRandomAmount(amounts[j] - 10, amounts[j] + 20), category: 'Food - Supermercado', description: descriptions[j], date: new Date(year, month, day).toISOString(), created_at: new Date(year, month, day, 18, 0).toISOString()
            });
        }

        // Transportation (every few days)
        for (let j = 0; j < 4; j++) {
            const day = Math.floor(Math.random() * 28) + 1;
            transactionsBatch.push({
                user_id: userId, type: 'expense', amount: getRandomAmount(40, 60), category: 'Transportation - Combustible', description: 'Repsol Gasolinera', date: new Date(year, month, day).toISOString(), created_at: new Date(year, month, day, 14, 0).toISOString()
            });
        }

        // Dining out / Coffee
        for (let j = 0; j < 10; j++) {
            const day = Math.floor(Math.random() * 28) + 1;
            const isCoffee = Math.random() > 0.4;
            transactionsBatch.push({
                user_id: userId, type: 'expense', amount: isCoffee ? getRandomAmount(2.5, 8) : getRandomAmount(25, 60), category: isCoffee ? 'Food - Cafeterías' : 'Food - Restaurantes', description: isCoffee ? 'Cafetería Specialty' : 'Cena con amigos', date: new Date(year, month, day).toISOString(), created_at: new Date(year, month, day, 21, 0).toISOString()
            });
        }

        // Random Shopping
        for (let j = 0; j < 3; j++) {
            const day = Math.floor(Math.random() * 28) + 1;
            transactionsBatch.push({
                user_id: userId, type: 'expense', amount: getRandomAmount(30, 200), category: 'Shopping - Ropa y calzado', description: 'Zara / Mango', date: new Date(year, month, day).toISOString(), created_at: new Date(year, month, day, 17, 0).toISOString()
            });
        }
    }

    // Insert Transactions
    const { error: txError } = await supabase.from('transactions').insert(transactionsBatch);
    if (txError) {
        console.error("Error inserting TX:", txError);
    } else {
        console.log(`Inserted ${transactionsBatch.length} transactions.`);
    }

    // 3. GOALS
    console.log("--> Creating Goals...");
    await supabase.from('goals').insert([
        { user_id: userId, name: 'Entrada Casa', current_amount: 12000, target_amount: 40000, deadline: new Date(now.getFullYear() + 2, now.getMonth(), 1).toISOString() },
        { user_id: userId, name: 'Fondo de Emergencia', current_amount: 8000, target_amount: 15000, deadline: new Date(now.getFullYear() + 1, now.getMonth(), 1).toISOString() }
    ]);

    // 4. WEALTH SNAPSHOT
    console.log("--> Setting up Wealth snapshot...");
    await supabase.from('user_wealth').insert({
        user_id: userId,
        liquid_cash: 10500,
        investments: 18500,
        real_estate: 0,
        liabilities: 800, // Small credit card debt
        last_recalibrated_date: new Date(now.getFullYear(), now.getMonth(), 1).toISOString()
    });

    console.log("\n=================================");
    console.log("✅ Simulation 8 Months Complete!");
    console.log("Email: " + email);
    console.log("Password: " + password);
    console.log("=================================\n");
}

generateData();
