import { createClient } from '@supabase/supabase-js';

const SUPABASE_URL = "https://kglawcgwryxrjvorxmbk.supabase.co";
const SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtnbGF3Y2d3cnl4cmp2b3J4bWJrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI0ODg5ODQsImV4cCI6MjA4ODA2NDk4NH0.qMNhMguri25hY6fFmbuDd9eEPMOXbl27ERbhnYe1oOk";

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

async function trimFutureTransactions() {
    console.log("--> Logging in...");
    const { data: auth, error: authError } = await supabase.auth.signInWithPassword({
        email: 'demo_1772734169879@finapp.com',
        password: 'securepassword123'
    });

    if (authError || !auth.user) {
        console.error("Login failed:", authError?.message);
        return;
    }

    console.log("--> Iniciando poda de transacciones futuras...");
    const now = new Date().toISOString();

    const { data, error } = await supabase
        .from('transactions')
        .delete()
        .gt('created_at', now)
        .select();

    if (error) {
        console.error("❌ Error al podar transacciones:", error.message);
    } else {
        console.log(`✅ Poda completada. Se eliminaron ${data.length} transacciones "fantasmas" del futuro.`);
    }
}

trimFutureTransactions();
