INSERT INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES
('cartebancaire', 'Carte Bancaire', 1, 1, 0);

CREATE TABLE `bank_account` (
  `identifier` varchar(255) NOT NULL,
  `cardname` varchar(255) NOT NULL,
  `cardnumber` varchar(255) NOT NULL,
  `creationdate` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `bank_account`
  ADD PRIMARY KEY (`cardnumber`);
COMMIT;

CREATE TABLE `bank_transactions` (
  `cardnumber` varchar(255) NOT NULL,
  `cardname` varchar(255) NOT NULL,
  `transactiontype` varchar(255) NOT NULL,
  `quantity` varchar(255) NOT NULL,
  `transactiondate` varchar(255) NOT NULL,
  `ingame` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `bank_transactions`
  ADD PRIMARY KEY (`transactiondate`);
COMMIT;
