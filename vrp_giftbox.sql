CREATE TABLE `vrp_giftbox` (
  `user_id` int(255) NOT NULL,
  `giftbox` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE `vrp_giftbox`
  ADD PRIMARY KEY (`user_id`);
