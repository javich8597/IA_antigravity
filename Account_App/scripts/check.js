import { createClient } from '@supabase/supabase-js';
const supabase = createClient('https://kglawcgwryxrjvorxmbk.supabase.co', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtnbGF3Y2d3cnl4cmp2b3J4bWJrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI0ODg5ODQsImV4cCI6MjA4ODA2NDk4NH0.qMNhMguri25hY6fFmbuDd9eEPMOXbl27ERbhnYe1oOk');
async function go() {
    const { data } = await supabase.from('transactions').select('created_at, description').order('created_at', { ascending: false }).limit(5);
    console.log(data);
}
go();
