import '../../models/transaction_model.dart';

/// Abstract interface for Open Banking integrations (e.g. Nordigen, Tink, Plaid)
abstract class BankingRepository {
  /// Fetches available bank accounts for the user
  Future<List<BankAccount>> fetchAccounts();

  /// Fetches transactions for a specific bank account over a date range
  Future<List<TransactionModel>> fetchTransactions(String accountId, {DateTime? startDate, DateTime? endDate});

  /// Initiates the OAuth linking process for a new bank account
  Future<String> getAccountLinkUrl(String institutionId, String redirectUrl);
}

/// Represents a linked bank account via Open Banking
class BankAccount {
  final String id;
  final String institutionName;
  final String name;
  final double balance;
  final String currency;

  BankAccount({
    required this.id,
    required this.institutionName,
    required this.name,
    required this.balance,
    required this.currency,
  });
}

/// Placeholder implementation for Nordigen (GoCardless) currently used in Spain/Europe
class NordigenBankingRepository implements BankingRepository {
  @override
  Future<List<BankAccount>> fetchAccounts() async {
    // TODO: Implement actual GoCardless API call
    print('DEBUG: Fetching accounts from Nordigen...');
    return [];
  }

  @override
  Future<List<TransactionModel>> fetchTransactions(String accountId, {DateTime? startDate, DateTime? endDate}) async {
    // TODO: Implement actual GoCardless API call
    print('DEBUG: Fetching transactions from Nordigen for account $accountId...');
    return [];
  }

  @override
  Future<String> getAccountLinkUrl(String institutionId, String redirectUrl) async {
    // TODO: Implement requisition creation
    print('DEBUG: Generating Nordigen link URL...');
    return 'https://ob.gocardless.com/mock-link';
  }
}
