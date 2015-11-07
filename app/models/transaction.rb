class Transaction < ActiveRecord::Base

  belongs_to :account

  def transfer_account
    Account.find(transfer_account_id) if transfer?
  end

  def previous
    self.class.
         where(account_id: account_id).
         where("id < ?", id).
         last
  end

  def current_transactions
    self.class.
         where(account_id: account_id).
         where("id <= ?", id)
  end

  def current_balance
    current_transactions.inject(account.init_balance) do |sum, transaction|
      sum + transaction.amount
    end
  end

  def transfer?
    category1 == "轉帳"
  end

  def transfer
    amount if transfer?
  end

  def income?
    category1 == "收入"
  end

  def income
    amount if income?
  end

  def expense?
    category1 == "支出"
  end

  def expense
    amount if expense?
  end

  def category
    if transfer?
      category1 + "(to #{transfer_account.try(:name)})"
    else
      category1 + "(#{try(:category2)})"
    end
  end
end
