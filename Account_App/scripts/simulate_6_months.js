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
    const months = 6;
    let transactionsBatch = [];

    // Helper functions
    const getRandomAmount = (min, max) => (Math.random() * (max - min) + min).toFixed(2);
    const getDaysInMonth = (year, month) => new Date(year, month + 1, 0).getDate();

    // 1. RECURRING DATA
    console.log("--> Setting up Recurring Transactions...");
    await supabase.from('recurring_transactions').insert([
        { user_id: userId, type: 'income', amount: 3200, category: 'Salary - Tech', frequency: 'monthly', description: 'Nómina Mensual', next_date: now.toISOString() },
        { user_id: userId, type: 'expense', amount: 950, category: 'Housing - Rent', frequency: 'monthly', description: 'Alquiler', next_date: now.toISOString() },
        { user_id: userId, type: 'expense', amount: 120, category: 'Utilities - Electric', frequency: 'monthly', description: 'Luz y Agua', next_date: now.toISOString() },
        { user_id: userId, type: 'expense', amount: 45, category: 'Entertainment - Subs', frequency: 'monthly', description: 'Gym', next_date: now.toISOString() },
        { user_id: userId, type: 'expense', amount: 15.99, category: 'Entertainment - Subs', frequency: 'monthly', description: 'Netflix', next_date: now.toISOString() },
    ]);

    // 2. BACKFILL 6 MONTHS DIRECT TRANSACTIONS
    console.log("--> Backfilling 6 months of historical transactions...");

    for (let i = months; i >= 0; i--) {
        const targetDate = new Date(now.getFullYear(), now.getMonth() - i, 1);
        const year = targetDate.getFullYear();
        const month = targetDate.getMonth();
        const daysInMonth = getDaysInMonth(year, month);

        // Fixed Incomes/Expenses for the month
        transactionsBatch.push({
            user_id: userId, type: 'income', amount: 3200, category: 'Salary', description: 'Nómina', date: new Date(year, month, 1).toISOString(), created_at: new Date(year, month, 1).toISOString()
        });
        transactionsBatch.push({
            user_id: userId, type: 'expense', amount: 950, category: 'Housing', description: 'Alquiler', date: new Date(year, month, 2).toISOString(), created_at: new Date(year, month, 2).toISOString()
        });
        transactionsBatch.push({
            user_id: userId, type: 'expense', amount: 120, category: 'Utilities', description: 'Suministros', date: new Date(year, month, 5).toISOString(), created_at: new Date(year, month, 5).toISOString()
        });
        transactionsBatch.push({
            user_id: userId, type: 'expense', amount: 60.99, category: 'Entertainment', description: 'Suscripciones', date: new Date(year, month, 15).toISOString(), created_at: new Date(year, month, 15).toISOString()
        });

        // Dynamic Variable Expenses per month
        // Groceries (4 times a month)
        for (let j = 0; j < 4; j++) {
            const day = Math.floor(Math.random() * 25) + 1;
            transactionsBatch.push({
                user_id: userId, type: 'expense', amount: getRandomAmount(60, 120), category: 'Food', description: 'Supermercado', date: new Date(year, month, day).toISOString(), created_at: new Date(year, month, day).toISOString()
            });
        }

        // Transport (every few days)
        for (let j = 0; j < 6; j++) {
            const day = Math.floor(Math.random() * 28) + 1;
            transactionsBatch.push({
                user_id: userId, type: 'expense', amount: getRandomAmount(10, 30), category: 'Transportation', description: 'Gasolina / Metro', date: new Date(year, month, day).toISOString(), created_at: new Date(year, month, day).toISOString()
            });
        }

        // Dining out / Coffee
        for (let j = 0; j < 8; j++) {
            const day = Math.floor(Math.random() * 28) + 1;
            const isCoffee = Math.random() > 0.5;
            transactionsBatch.push({
                user_id: userId, type: 'expense', amount: isCoffee ? getRandomAmount(2.5, 6) : getRandomAmount(20, 50), category: 'Food', description: isCoffee ? 'Cafetería' : 'Restaurante', date: new Date(year, month, day).toISOString(), created_at: new Date(year, month, day).toISOString()
            });
        }

        // Random Shopping
        for (let j = 0; j < 2; j++) {
            const day = Math.floor(Math.random() * 28) + 1;
            transactionsBatch.push({
                user_id: userId, type: 'expense', amount: getRandomAmount(40, 150), category: 'Shopping', description: 'Amaszon / Ropa', date: new Date(year, month, day).toISOString(), created_at: new Date(year, month, day).toISOString()
            });
        }
    }

    // Insert Transactions
    const { error: txError } = await supabase.from('transactions').insert(transactionsBatch);
    if (txError) console.error("Error inserting TX:", txError);

    // 3. GOALS
    console.log("--> Creating Goals...");
    await supabase.from('goals').insert([
        { user_id: userId, title: 'Entrada Coche', current_amount: 3500, target_amount: 10000, target_date: new Date(now.getFullYear(), now.getMonth() + 10, 1).toISOString() },
        { user_id: userId, title: 'Fondo de Emergencia', current_amount: 6000, target_amount: 15000, target_date: new Date(now.getFullYear() + 1, now.getMonth(), 1).toISOString() }
    ]);

    // 4. WEALTH SNAPSHOT
    console.log("--> Setting up Wealth snapshot...");
    await supabase.from('user_wealth').insert({
        user_id: userId,
        liquid_cash: 8500,
        investments: 12500,
        real_estate: 0,
        liabilities: 1400, // Maybe a small loan or credit card debt
        last_recalibrated_date: new Date(now.getFullYear(), now.getMonth(), 1).toISOString() // Recalibrated start of current month
    });

    console.log("--> Simulation Complete! You now have 6 months of data, active goals, and configured wealth stats.");
}

generateData();
