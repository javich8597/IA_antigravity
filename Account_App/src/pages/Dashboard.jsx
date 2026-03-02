import DashboardCard from '../components/Dashboard';
import TransactionForm from '../components/TransactionForm';
import TransactionList from '../components/TransactionList';

export default function Dashboard() {
    return (
        <div className="main-grid">
            <aside className="sidebar">
                <TransactionForm />
            </aside>
            <section className="dashboard-content">
                <DashboardCard />
            </section>
        </div>
    );
}
