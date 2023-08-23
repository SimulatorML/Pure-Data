/*
Tables meta-data:

sales (
	day date nullable,
	item_id int nullable,
	qty int nullable,
	price decimal nullable,
	revenue decimal nullable,
	pay_card varchar nullable
)

views (
	dt date nullable,
	item_id int nullable,
	views int nullable,
	clicks int nullable,
	payments int nullable,
)

av_table_none (
	index datetime nullable,
	revenue decimal nullable,
	qty int nullable
)
*/

-- CTE for tables
with cte_sales as (
    select '2022-10-21' as day, 100 as item_id, null as qty, 120.0 as price, 500.0 as revenue, 'visa' as pay_card
    union all select '2022-10-21', 100, 6, 120.0, 720.0, 'visa'
    union all select '2022-10-21', 200, 2, 200.0, 400.0, null
    union all select '2022-10-22', 300, null, 85.0, 850.0, 'unionpay'
    union all select '2022-10-22', 100, 3, 110.0, 330.0, 'tinkoff'
    union all select '2022-10-22', 200, null, 200.0, 1600.0, 'paypal'
    union all select '2022-10-23', 300, 0, 90.0, 0.0, 'mastercard'
    union all select '2022-10-23', 100, 5, 120.0, 500.0, 'visa'
    union all select '2022-10-23', 100, 6, 120.0, 720.0, 'masteRcard'
    union all select '2022-10-23', 200, 2, 200.0, 400.0, 'mastercard'
    union all select '2022-10-23', 300, null, 85.0, 850.0, 'visa'
    union all select '2022-10-27', 100, 3, 110.0, 33.0, null
    union all select '2022-10-27', 200, 8, 200.0, 160.0, 'unionpay'
    union all select '2022-10-27', 300, 0, 90.0, 0.0, 'visa'
    union all select '2022-10-27', 100, null, 120.0, 500.0, 'mastercard'
    union all select '2022-10-28', 100, 6, 120.0, 720.0, 'unionpay'
    union all select '2022-10-29', 200, 2, 200.0, 400.0, 'visa'
    union all select '2022-10-29', 300, null, 85.0, 850.0, 'visa'
    union all select '2022-10-29', 100, 3, 110.0, 330.0, 'unionpay'
    union all select '2022-10-30', 200, 8, 0.0, 160.0, 'visa'
    union all select '2022-10-31', 300, 1, 0.0, 1000.0, 'visa'
),
cte_views as (
    select '2022-09-24' as dt, 100 as item_id, 0 as views, 219 as clicks, 56 as payments
    union all select '2022-09-24', 200, 0, 343, 1
    union all select '2022-09-24', 300, 0, 102, 71
    union all select '2022-09-23', 100, null, 730, 18
    union all select '2022-09-23', 200, null, 203, 9
    union all select '2022-09-23', 300, 0, 0, 2
    union all select '2022-09-22', 100, null, 123, 20
    union all select '2022-09-22', 200, 0, 500, 13
    union all select '2022-09-22', 300, 0, 68, 2
    union all select '2022-09-25', 100, 1000, 219, 56
    union all select '2022-09-25', 200, 1248, 343, 1
    union all select '2022-09-25', 300, 993, 102, 71
    union all select '2022-09-25', 100, 3244, 730, 18
    union all select '2022-09-25', 200, null, 203, 9
    union all select '2022-09-25', 300, 0, 0, 2
    union all select '2022-09-21', 100, 0, 123, 20
    union all select '2022-09-21', 200, 50, 500, 13
    union all select '2022-09-21', 300, 0, 68, 2
),
cte_av_table_none as (
    select '2022-01-01 01:10:00' as index, 238.0 as revenue, 58 as qty
    union all
    select '2022-01-01 01:10:00',654.0,85
    union all
    select '2022-01-01 02:05:00',292.0,35
    union all
    select '2022-01-01 03:14:00',896.0,6
    union all
    select '2022-01-01 04:28:00',114.0,69
    union all
    select '2022-01-01 07:03:00',454.0,56
    union all
    select '2022-01-01 08:35:00',266.0,23
    union all
    select '2022-01-01 09:18:00',340.0,79
    union all
    select '2022-01-01 09:25:00',826.0,33
    union all
    select '2022-01-01 09:35:00',916.0,99
    union all
    select '2022-01-01 11:53:00',492.0,82
    union all
    select '2022-01-01 13:03:00',870.0,96
    union all
    select '2022-01-01 13:47:00',666.0,67
    union all
    select '2022-01-01 13:56:00',774.0,54
    union all
    select '2022-01-01 14:18:00',394.0,53
    union all
    select '2022-01-01 15:43:00',598.0,62
    union all
    select '2022-01-01 18:35:00',870.0,36
    union all
    select '2022-01-01 18:59:00',386.0,47
    union all
    select '2022-01-01 21:45:00',176.0,44
    union all
    select '2022-01-01 23:48:00',272.0,75
    union all
    select '2022-01-02 00:01:00',674.0,86
    union all
    select '2022-01-02 02:06:00',476.0,77
    union all
    select '2022-01-02 03:07:00',924.0,68
    union all
    select '2022-01-02 05:32:00',190.0,23
    union all
    select '2022-01-02 05:51:00',200.0,63
    union all
    select '2022-01-02 05:56:00',256.0,79
    union all
    select '2022-01-02 05:56:00',122.0,55
    union all
    select '2022-01-02 05:58:00',726.0,87
    union all
    select '2022-01-02 06:41:00',776.0,27
    union all
    select '2022-01-02 06:54:00',484.0,24
    union all
    select '2022-01-02 07:16:00',994.0,7
    union all
    select '2022-01-02 07:41:00',598.0,95
    union all
    select '2022-01-02 09:37:00',506.0,43
    union all
    select '2022-01-02 10:05:00',784.0,86
    union all
    select '2022-01-02 11:11:00',640.0,21
    union all
    select '2022-01-02 11:44:00',224.0,56
    union all
    select '2022-01-02 12:34:00',310.0,34
    union all
    select '2022-01-02 13:02:00',660.0,8
    union all
    select '2022-01-02 14:25:00',192.0,1
    union all
    select '2022-01-02 15:02:00',274.0,72
    union all
    select '2022-01-02 16:10:00',942.0,89
    union all
    select '2022-01-02 16:53:00',388.0,52
    union all
    select '2022-01-02 17:49:00',310.0,32
    union all
    select '2022-01-02 18:49:00',500.0,41
    union all
    select '2022-01-02 19:05:00',582.0,60
    union all
    select '2022-01-02 20:03:00',856.0,23
    union all
    select '2022-01-02 20:19:00',606.0,67
    union all
    select '2022-01-02 20:37:00',880.0,98
    union all
    select '2022-01-02 20:50:00',384.0,86
    union all
    select '2022-01-02 20:52:00',584.0,3
    union all
    select '2022-01-02 22:30:00',258.0,8
    union all
    select '2022-01-03 00:44:00',894.0,93
    union all
    select '2022-01-03 01:46:00',622.0,32
    union all
    select '2022-01-03 03:52:00',116.0,57
    union all
    select '2022-01-03 05:14:00',856.0,46
    union all
    select '2022-01-03 06:19:00',940.0,81
    union all
    select '2022-01-03 06:41:00',288.0,73
    union all
    select '2022-01-03 06:59:00',998.0,32
    union all
    select '2022-01-03 07:30:00',602.0,86
    union all
    select '2022-01-03 07:36:00',438.0,93
    union all
    select '2022-01-03 08:14:00',516.0,56
    union all
    select '2022-01-03 08:53:00',440.0,25
    union all
    select '2022-01-03 09:24:00',964.0,11
    union all
    select '2022-01-03 09:31:00',276.0,86
    union all
    select '2022-01-03 09:40:00',368.0,84
    union all
    select '2022-01-03 10:10:00',996.0,2
    union all
    select '2022-01-03 10:42:00',442.0,82
    union all
    select '2022-01-03 12:43:00',844.0,16
    union all
    select '2022-01-03 12:52:00',778.0,74
    union all
    select '2022-01-03 15:47:00',142.0,78
    union all
    select '2022-01-03 15:52:00',602.0,92
    union all
    select '2022-01-03 18:00:00',104.0,49
    union all
    select '2022-01-03 18:10:00',890.0,97
    union all
    select '2022-01-03 18:53:00',722.0,23
    union all
    select '2022-01-03 19:13:00',172.0,92
    union all
    select '2022-01-03 20:43:00',622.0,12
    union all
    select '2022-01-03 20:55:00',700.0,10
    union all
    select '2022-01-03 23:01:00',586.0,52
    union all
    select '2022-01-04 02:15:00',510.0,23
    union all
    select '2022-01-04 02:40:00',510.0,99
    union all
    select '2022-01-04 02:59:00',206.0,17
    union all
    select '2022-01-04 03:29:00',158.0,90
    union all
    select '2022-01-04 03:36:00',824.0,99
    union all
    select '2022-01-04 04:54:00',796.0,19
    union all
    select '2022-01-04 07:44:00',222.0,89
    union all
    select '2022-01-04 08:40:00',936.0,57
    union all
    select '2022-01-04 08:48:00',458.0,87
    union all
    select '2022-01-04 09:53:00',688.0,80
    union all
    select '2022-01-04 13:01:00',820.0,67
    union all
    select '2022-01-04 13:40:00',402.0,33
    union all
    select '2022-01-04 14:34:00',268.0,49
    union all
    select '2022-01-04 14:47:00',942.0,34
    union all
    select '2022-01-04 17:59:00',626.0,54
    union all
    select '2022-01-04 18:16:00',936.0,64
    union all
    select '2022-01-04 19:16:00',916.0,48
    union all
    select '2022-01-04 19:58:00',752.0,37
    union all
    select '2022-01-04 20:00:00',734.0,74
    union all
    select '2022-01-04 20:37:00',690.0,60
    union all
    select '2022-01-04 21:20:00',348.0,6
    union all
    select '2022-01-04 22:05:00',742.0,44
    union all
    select '2022-01-04 22:11:00',618.0,45
    union all
    select '2022-01-04 22:19:00',886.0,20
    union all
    select '2022-01-04 22:40:00',962.0,33
    union all
    select '2022-01-04 22:42:00',120.0,88
    union all
    select '2022-01-04 22:50:00',508.0,99
    union all
    select '2022-01-04 23:35:00',310.0,8
    union all
    select '2022-01-05 00:37:00',362.0,69
    union all
    select '2022-01-05 00:50:00',228.0,24
    union all
    select '2022-01-05 01:07:00',742.0,12
    union all
    select '2022-01-05 01:35:00',822.0,2
    union all
    select '2022-01-05 01:42:00',786.0,17
    union all
    select '2022-01-05 02:29:00',558.0,59
    union all
    select '2022-01-05 03:27:00',120.0,32
    union all
    select '2022-01-05 04:32:00',776.0,51
    union all
    select '2022-01-05 04:49:00',100.0,12
    union all
    select '2022-01-05 09:07:00',946.0,50
    union all
    select '2022-01-05 09:25:00',416.0,76
    union all
    select '2022-01-05 10:32:00',888.0,69
    union all
    select '2022-01-05 11:18:00',262.0,12
    union all
    select '2022-01-05 12:08:00',708.0,44
    union all
    select '2022-01-05 13:14:00',572.0,17
    union all
    select '2022-01-05 13:32:00',732.0,12
    union all
    select '2022-01-05 13:54:00',286.0,40
    union all
    select '2022-01-05 14:10:00',826.0,79
    union all
    select '2022-01-05 14:19:00',858.0,57
    union all
    select '2022-01-05 15:15:00',960.0,31
    union all
    select '2022-01-05 15:31:00',808.0,73
    union all
    select '2022-01-05 16:09:00',676.0,9
    union all
    select '2022-01-05 17:55:00',256.0,78
    union all
    select '2022-01-05 18:53:00',366.0,23
    union all
    select '2022-01-05 19:24:00',550.0,65
    union all
    select '2022-01-05 20:24:00',792.0,63
    union all
    select '2022-01-05 20:32:00',652.0,89
    union all
    select '2022-01-05 23:59:00',368.0,22
    union all
    select '2022-01-05 23:59:00',562.0,59
    union all
    select '2022-01-06 02:35:00',554.0,25
    union all
    select '2022-01-06 03:55:00',462.0,47
    union all
    select '2022-01-06 04:21:00',644.0,74
    union all
    select '2022-01-06 04:55:00',214.0,55
    union all
    select '2022-01-06 06:00:00',406.0,84
    union all
    select '2022-01-06 06:02:00',208.0,82
    union all
    select '2022-01-06 06:16:00',238.0,29
    union all
    select '2022-01-06 06:29:00',914.0,91
    union all
    select '2022-01-06 07:42:00',628.0,72
    union all
    select '2022-01-06 07:50:00',122.0,87
    union all
    select '2022-01-06 08:02:00',196.0,76
    union all
    select '2022-01-06 08:41:00',926.0,80
    union all
    select '2022-01-06 08:47:00',842.0,42
    union all
    select '2022-01-06 10:06:00',452.0,41
    union all
    select '2022-01-06 11:21:00',326.0,79
    union all
    select '2022-01-06 12:15:00',664.0,66
    union all
    select '2022-01-06 12:35:00',220.0,91
    union all
    select '2022-01-06 13:23:00',668.0,67
    union all
    select '2022-01-06 14:17:00',272.0,81
    union all
    select '2022-01-06 16:32:00',678.0,1
    union all
    select '2022-01-06 16:45:00',346.0,31
    union all
    select '2022-01-06 17:42:00',368.0,18
    union all
    select '2022-01-06 18:44:00',824.0,62
    union all
    select '2022-01-06 20:02:00',470.0,31
    union all
    select '2022-01-06 20:52:00',914.0,73
    union all
    select '2022-01-06 20:56:00',412.0,32
    union all
    select '2022-01-07 00:14:00',580.0,55
    union all
    select '2022-01-07 00:53:00',922.0,14
    union all
    select '2022-01-07 04:01:00',172.0,44
    union all
    select '2022-01-07 04:30:00',966.0,5
    union all
    select '2022-01-07 04:47:00',608.0,48
    union all
    select '2022-01-07 05:31:00',670.0,54
    union all
    select '2022-01-07 06:43:00',760.0,19
    union all
    select '2022-01-07 06:49:00',158.0,24
    union all
    select '2022-01-07 06:56:00',426.0,66
    union all
    select '2022-01-07 07:53:00',834.0,70
    union all
    select '2022-01-07 08:47:00',194.0,42
    union all
    select '2022-01-07 10:30:00',874.0,97
    union all
    select '2022-01-07 11:11:00',446.0,69
    union all
    select '2022-01-07 12:28:00',192.0,74
    union all
    select '2022-01-07 13:03:00',330.0,56
    union all
    select '2022-01-07 14:01:00',342.0,36
    union all
    select '2022-01-07 15:15:00',510.0,55
    union all
    select '2022-01-07 15:28:00',728.0,59
    union all
    select '2022-01-07 15:50:00',412.0,54
    union all
    select '2022-01-07 16:52:00',742.0,34
    union all
    select '2022-01-07 18:31:00',862.0,84
    union all
    select '2022-01-07 18:46:00',860.0,92
    union all
    select '2022-01-07 20:06:00',500.0,61
    union all
    select '2022-01-07 20:29:00',872.0,9
    union all
    select '2022-01-07 21:33:00',190.0,28
    union all
    select '2022-01-07 22:59:00',720.0,9
    union all
    select '2022-01-07 23:16:00',106.0,82
    union all
    select '2022-01-07 23:39:00',698.0,67
    union all
    select '2022-01-08 00:08:00',844.0,92
    union all
    select '2022-01-08 01:34:00',854.0,7
    union all
    select '2022-01-08 01:46:00',752.0,34
    union all
    select '2022-01-08 02:44:00',394.0,90
    union all
    select '2022-01-08 03:57:00',938.0,81
    union all
    select '2022-01-08 04:00:00',434.0,42
    union all
    select '2022-01-08 05:09:00',124.0,36
    union all
    select '2022-01-08 06:15:00',202.0,98
    union all
    select '2022-01-08 07:52:00',558.0,82
    union all
    select '2022-01-08 08:23:00',802.0,81
    union all
    select '2022-01-08 09:10:00',754.0,15
    union all
    select '2022-01-08 10:17:00',462.0,58
    union all
    select '2022-01-08 10:19:00',716.0,85
    union all
    select '2022-01-08 11:36:00',408.0,27
    union all
    select '2022-01-08 11:51:00',394.0,72
    union all
    select '2022-01-08 12:18:00',582.0,24
    union all
    select '2022-01-08 13:50:00',220.0,3
    union all
    select '2022-01-08 14:18:00',140.0,50
    union all
    select '2022-01-08 14:40:00',838.0,23
    union all
    select '2022-01-08 16:24:00',102.0,36
    union all
    select '2022-01-08 16:29:00',356.0,79
    union all
    select '2022-01-08 16:38:00',142.0,29
    union all
    select '2022-01-08 17:21:00',672.0,80
    union all
    select '2022-01-08 19:19:00',296.0,97
    union all
    select '2022-01-08 20:56:00',556.0,4
    union all
    select '2022-01-08 21:06:00',168.0,70
    union all
    select '2022-01-08 23:15:00',932.0,41
    union all
    select '2022-01-09 00:54:00',910.0,37
    union all
    select '2022-01-09 01:44:00',376.0,2
    union all
    select '2022-01-09 02:26:00',270.0,35
    union all
    select '2022-01-09 03:23:00',984.0,65
    union all
    select '2022-01-09 09:00:00',504.0,88
    union all
    select '2022-01-09 09:31:00',648.0,47
    union all
    select '2022-01-09 09:37:00',762.0,58
    union all
    select '2022-01-09 10:07:00',672.0,78
    union all
    select '2022-01-09 10:09:00',726.0,94
    union all
    select '2022-01-09 10:50:00',794.0,83
    union all
    select '2022-01-09 10:51:00',440.0,55
    union all
    select '2022-01-09 15:30:00',772.0,15
    union all
    select '2022-01-09 15:59:00',182.0,35
    union all
    select '2022-01-09 16:02:00',588.0,14
    union all
    select '2022-01-09 16:41:00',518.0,68
    union all
    select '2022-01-09 18:42:00',658.0,96
    union all
    select '2022-01-09 18:43:00',946.0,86
    union all
    select '2022-01-09 21:09:00',736.0,2
    union all
    select '2022-01-10 02:56:00',688.0,47
    union all
    select '2022-01-10 03:11:00',952.0,55
    union all
    select '2022-01-10 06:15:00',478.0,1
    union all
    select '2022-01-10 06:19:00',410.0,23
    union all
    select '2022-01-10 07:15:00',686.0,38
    union all
    select '2022-01-10 08:05:00',944.0,42
    union all
    select '2022-01-10 08:23:00',538.0,72
    union all
    select '2022-01-10 09:10:00',730.0,68
    union all
    select '2022-01-10 09:46:00',634.0,98
    union all
    select '2022-01-10 09:59:00',312.0,20
    union all
    select '2022-01-10 10:23:00',988.0,25
    union all
    select '2022-01-10 11:50:00',328.0,89
    union all
    select '2022-01-10 13:59:00',734.0,86
    union all
    select '2022-01-10 16:42:00',728.0,62
    union all
    select '2022-01-10 21:32:00',522.0,14
    union all
    select '2022-01-10 22:25:00',390.0,48
    union all
    select '2022-01-11 00:37:00',492.0,53
    union all
    select '2022-01-11 02:52:00',180.0,1
    union all
    select '2022-01-11 03:05:00',632.0,79
    union all
    select '2022-01-11 04:35:00',654.0,57
    union all
    select '2022-01-11 06:50:00',200.0,51
    union all
    select '2022-01-11 08:05:00',902.0,42
    union all
    select '2022-01-11 08:37:00',308.0,51
    union all
    select '2022-01-11 10:51:00',656.0,58
    union all
    select '2022-01-11 13:17:00',360.0,62
    union all
    select '2022-01-11 16:51:00',292.0,95
    union all
    select '2022-01-11 17:36:00',800.0,95
    union all
    select '2022-01-11 21:52:00',664.0,73
    union all
    select '2022-01-11 22:05:00',660.0,91
    union all
    select '2022-01-11 23:48:00',952.0,36
    union all
    select '2022-01-12 01:38:00',544.0,79
    union all
    select '2022-01-12 02:51:00',854.0,7
    union all
    select '2022-01-12 02:56:00',394.0,75
    union all
    select '2022-01-12 04:10:00',340.0,33
    union all
    select '2022-01-12 04:32:00',998.0,42
    union all
    select '2022-01-12 07:51:00',396.0,33
    union all
    select '2022-01-12 08:17:00',548.0,31
    union all
    select '2022-01-12 09:17:00',716.0,42
    union all
    select '2022-01-12 09:58:00',840.0,25
    union all
    select '2022-01-12 10:01:00',712.0,18
    union all
    select '2022-01-12 10:20:00',836.0,68
    union all
    select '2022-01-12 11:06:00',446.0,89
    union all
    select '2022-01-12 14:20:00',320.0,48
    union all
    select '2022-01-12 14:57:00',476.0,85
    union all
    select '2022-01-12 15:53:00',258.0,85
    union all
    select '2022-01-12 16:20:00',430.0,32
    union all
    select '2022-01-12 19:26:00',540.0,70
    union all
    select '2022-01-12 19:26:00',806.0,97
    union all
    select '2022-01-12 19:28:00',818.0,34
    union all
    select '2022-01-12 19:59:00',146.0,68
    union all
    select '2022-01-12 20:15:00',144.0,14
    union all
    select '2022-01-12 20:42:00',874.0,49
    union all
    select '2022-01-12 23:17:00',714.0,56
    union all
    select '2022-01-13 00:58:00',268.0,48
    union all
    select '2022-01-13 02:04:00',922.0,31
    union all
    select '2022-01-13 02:17:00',508.0,18
    union all
    select '2022-01-13 02:44:00',804.0,9
    union all
    select '2022-01-13 03:12:00',234.0,38
    union all
    select '2022-01-13 03:20:00',488.0,90
    union all
    select '2022-01-13 06:30:00',952.0,88
    union all
    select '2022-01-13 09:56:00',280.0,77
    union all
    select '2022-01-13 10:08:00',498.0,99
    union all
    select '2022-01-13 10:23:00',362.0,52
    union all
    select '2022-01-13 11:44:00',624.0,84
    union all
    select '2022-01-13 13:01:00',780.0,67
    union all
    select '2022-01-13 13:47:00',928.0,93
    union all
    select '2022-01-13 15:20:00',898.0,52
    union all
    select '2022-01-13 15:29:00',338.0,32
    union all
    select '2022-01-13 16:19:00',978.0,27
    union all
    select '2022-01-13 16:41:00',428.0,38
    union all
    select '2022-01-13 16:42:00',210.0,99
    union all
    select '2022-01-13 17:38:00',870.0,65
    union all
    select '2022-01-14 00:01:00',918.0,24
    union all
    select '2022-01-14 01:04:00',572.0,68
    union all
    select '2022-01-14 01:28:00',698.0,2
    union all
    select '2022-01-14 04:11:00',194.0,11
    union all
    select '2022-01-14 04:17:00',866.0,49
    union all
    select '2022-01-14 04:26:00',502.0,46
    union all
    select '2022-01-14 05:23:00',238.0,8
    union all
    select '2022-01-14 06:35:00',718.0,5
    union all
    select '2022-01-14 06:36:00',268.0,64
    union all
    select '2022-01-14 07:02:00',294.0,72
    union all
    select '2022-01-14 08:16:00',100.0,2
    union all
    select '2022-01-14 08:21:00',550.0,14
    union all
    select '2022-01-14 12:21:00',548.0,50
    union all
    select '2022-01-14 12:36:00',644.0,20
    union all
    select '2022-01-14 12:45:00',912.0,12
    union all
    select '2022-01-14 13:21:00',472.0,4
    union all
    select '2022-01-14 16:24:00',404.0,46
    union all
    select '2022-01-14 16:37:00',362.0,63
    union all
    select '2022-01-14 18:29:00',924.0,33
    union all
    select '2022-01-14 19:58:00',746.0,46
    union all
    select '2022-01-14 20:32:00',664.0,73
    union all
    select '2022-01-14 21:11:00',370.0,55
    union all
    select '2022-01-14 21:36:00',850.0,68
    union all
    select '2022-01-14 22:36:00',766.0,67
    union all
    select '2022-01-15 00:26:00',486.0,32
    union all
    select '2022-01-15 02:48:00',836.0,25
    union all
    select '2022-01-15 03:20:00',156.0,48
    union all
    select '2022-01-15 03:40:00',504.0,37
    union all
    select '2022-01-15 06:32:00',726.0,14
    union all
    select '2022-01-15 07:51:00',348.0,1
    union all
    select '2022-01-15 09:07:00',182.0,81
    union all
    select '2022-01-15 09:31:00',790.0,38
    union all
    select '2022-01-15 10:23:00',786.0,51
    union all
    select '2022-01-15 10:34:00',830.0,60
    union all
    select '2022-01-15 10:44:00',696.0,50
    union all
    select '2022-01-15 12:21:00',968.0,15
    union all
    select '2022-01-15 12:54:00',998.0,6
    union all
    select '2022-01-15 13:41:00',826.0,48
    union all
    select '2022-01-15 18:15:00',624.0,54
    union all
    select '2022-01-15 20:41:00',484.0,27
    union all
    select '2022-01-15 20:44:00',952.0,5
    union all
    select '2022-01-16 01:38:00',872.0,74
    union all
    select '2022-01-16 04:20:00',856.0,24
    union all
    select '2022-01-16 05:03:00',400.0,40
    union all
    select '2022-01-16 05:33:00',476.0,79
    union all
    select '2022-01-16 05:47:00',396.0,12
    union all
    select '2022-01-16 05:52:00',632.0,31
    union all
    select '2022-01-16 05:52:00',328.0,15
    union all
    select '2022-01-16 06:31:00',768.0,66
    union all
    select '2022-01-16 07:48:00',416.0,59
    union all
    select '2022-01-16 07:59:00',650.0,66
    union all
    select '2022-01-16 09:30:00',608.0,10
    union all
    select '2022-01-16 09:36:00',616.0,38
    union all
    select '2022-01-16 10:57:00',106.0,35
    union all
    select '2022-01-16 11:14:00',238.0,23
    union all
    select '2022-01-16 11:28:00',568.0,71
    union all
    select '2022-01-16 15:28:00',450.0,60
    union all
    select '2022-01-16 16:56:00',916.0,23
    union all
    select '2022-01-16 18:40:00',606.0,16
    union all
    select '2022-01-16 19:20:00',542.0,26
    union all
    select '2022-01-16 19:48:00',532.0,72
    union all
    select '2022-01-16 20:11:00',910.0,28
    union all
    select '2022-01-16 20:28:00',786.0,81
    union all
    select '2022-01-16 21:25:00',532.0,50
    union all
    select '2022-01-16 22:58:00',480.0,97
    union all
    select '2022-01-16 23:10:00',890.0,28
    union all
    select '2022-01-17 01:40:00',712.0,18
    union all
    select '2022-01-17 03:54:00',284.0,43
    union all
    select '2022-01-17 05:30:00',980.0,22
    union all
    select '2022-01-17 05:35:00',622.0,52
    union all
    select '2022-01-17 07:22:00',278.0,11
    union all
    select '2022-01-17 07:34:00',832.0,74
    union all
    select '2022-01-17 09:04:00',874.0,52
    union all
    select '2022-01-17 09:31:00',704.0,28
    union all
    select '2022-01-17 09:45:00',930.0,71
    union all
    select '2022-01-17 12:11:00',480.0,16
    union all
    select '2022-01-17 12:30:00',124.0,27
    union all
    select '2022-01-17 12:42:00',862.0,39
    union all
    select '2022-01-17 14:24:00',196.0,47
    union all
    select '2022-01-17 16:05:00',968.0,35
    union all
    select '2022-01-17 16:14:00',294.0,44
    union all
    select '2022-01-17 17:35:00',266.0,56
    union all
    select '2022-01-17 19:53:00',512.0,49
    union all
    select '2022-01-17 20:14:00',434.0,81
    union all
    select '2022-01-17 20:58:00',370.0,97
    union all
    select '2022-01-17 21:55:00',462.0,76
    union all
    select '2022-01-18 00:55:00',586.0,4
    union all
    select '2022-01-18 02:51:00',996.0,67
    union all
    select '2022-01-18 05:06:00',942.0,79
    union all
    select '2022-01-18 06:00:00',244.0,97
    union all
    select '2022-01-18 06:20:00',590.0,95
    union all
    select '2022-01-18 06:56:00',446.0,11
    union all
    select '2022-01-18 07:09:00',846.0,45
    union all
    select '2022-01-18 08:33:00',868.0,5
    union all
    select '2022-01-18 08:40:00',638.0,17
    union all
    select '2022-01-18 08:42:00',580.0,92
    union all
    select '2022-01-18 10:12:00',286.0,74
    union all
    select '2022-01-18 10:42:00',942.0,7
    union all
    select '2022-01-18 12:04:00',678.0,82
    union all
    select '2022-01-18 12:34:00',792.0,60
    union all
    select '2022-01-18 12:42:00',924.0,75
    union all
    select '2022-01-18 13:38:00',810.0,12
    union all
    select '2022-01-18 13:44:00',836.0,52
    union all
    select '2022-01-18 18:43:00',580.0,81
    union all
    select '2022-01-18 20:08:00',220.0,22
    union all
    select '2022-01-18 20:35:00',914.0,42
    union all
    select '2022-01-18 21:01:00',842.0,90
    union all
    select '2022-01-18 23:27:00',720.0,88
    union all
    select '2022-01-19 00:42:00',610.0,95
    union all
    select '2022-01-19 00:57:00',794.0,81
    union all
    select '2022-01-19 04:58:00',204.0,58
    union all
    select '2022-01-19 06:42:00',368.0,9
    union all
    select '2022-01-19 07:42:00',256.0,21
    union all
    select '2022-01-19 08:01:00',330.0,82
    union all
    select '2022-01-19 08:42:00',718.0,39
    union all
    select '2022-01-19 09:23:00',826.0,60
    union all
    select '2022-01-19 16:28:00',864.0,26
    union all
    select '2022-01-19 17:06:00',216.0,81
    union all
    select '2022-01-19 18:23:00',866.0,16
    union all
    select '2022-01-19 21:01:00',384.0,15
    union all
    select '2022-01-19 22:47:00',802.0,32
    union all
    select '2022-01-19 23:03:00',426.0,94
    union all
    select '2022-01-19 23:22:00',398.0,65
    union all
    select '2022-01-20 01:06:00',362.0,44
    union all
    select '2022-01-20 01:21:00',904.0,43
    union all
    select '2022-01-20 02:00:00',516.0,19
    union all
    select '2022-01-20 02:18:00',688.0,31
    union all
    select '2022-01-20 02:23:00',744.0,9
    union all
    select '2022-01-20 03:02:00',286.0,5
    union all
    select '2022-01-20 04:34:00',896.0,15
    union all
    select '2022-01-20 06:02:00',900.0,68
    union all
    select '2022-01-20 07:18:00',652.0,38
    union all
    select '2022-01-20 07:48:00',838.0,48
    union all
    select '2022-01-20 08:09:00',686.0,30
    union all
    select '2022-01-20 09:01:00',966.0,75
    union all
    select '2022-01-20 11:58:00',548.0,27
    union all
    select '2022-01-20 12:33:00',718.0,88
    union all
    select '2022-01-20 13:51:00',474.0,26
    union all
    select '2022-01-20 13:51:00',240.0,92
    union all
    select '2022-01-20 15:10:00',616.0,7
    union all
    select '2022-01-20 18:20:00',392.0,18
    union all
    select '2022-01-20 18:24:00',926.0,97
    union all
    select '2022-01-20 18:28:00',728.0,83
    union all
    select '2022-01-20 19:11:00',358.0,16
    union all
    select '2022-01-20 20:07:00',142.0,38
    union all
    select '2022-01-20 20:13:00',674.0,90
    union all
    select '2022-01-20 22:10:00',388.0,9
    union all
    select '2022-01-20 23:39:00',624.0,8
    union all
    select '2022-01-21 03:53:00',614.0,84
    union all
    select '2022-01-21 03:54:00',386.0,24
    union all
    select '2022-01-21 04:27:00',214.0,56
    union all
    select '2022-01-21 05:01:00',542.0,94
    union all
    select '2022-01-21 06:59:00',566.0,25
    union all
    select '2022-01-21 07:13:00',846.0,96
    union all
    select '2022-01-21 09:09:00',146.0,98
    union all
    select '2022-01-21 09:23:00',758.0,48
    union all
    select '2022-01-21 09:38:00',566.0,29
    union all
    select '2022-01-21 12:50:00',312.0,57
    union all
    select '2022-01-21 14:23:00',778.0,63
    union all
    select '2022-01-21 16:30:00',318.0,71
    union all
    select '2022-01-21 16:48:00',872.0,14
    union all
    select '2022-01-21 20:00:00',762.0,71
    union all
    select '2022-01-21 21:51:00',466.0,1
    union all
    select '2022-01-21 22:40:00',830.0,78
    union all
    select '2022-01-21 22:45:00',574.0,78
    union all
    select '2022-01-22 00:52:00',470.0,68
    union all
    select '2022-01-22 02:57:00',972.0,15
    union all
    select '2022-01-22 03:08:00',444.0,36
    union all
    select '2022-01-22 03:10:00',134.0,50
    union all
    select '2022-01-22 03:10:00',558.0,20
    union all
    select '2022-01-22 04:15:00',564.0,64
    union all
    select '2022-01-22 04:34:00',142.0,26
    union all
    select '2022-01-22 05:03:00',638.0,43
    union all
    select '2022-01-22 05:32:00',836.0,52
    union all
    select '2022-01-22 07:03:00',170.0,48
    union all
    select '2022-01-22 07:55:00',794.0,11
    union all
    select '2022-01-22 07:59:00',664.0,86
    union all
    select '2022-01-22 09:05:00',104.0,49
    union all
    select '2022-01-22 10:22:00',932.0,18
    union all
    select '2022-01-22 11:52:00',546.0,92
    union all
    select '2022-01-22 12:29:00',484.0,54
    union all
    select '2022-01-22 13:10:00',296.0,48
    union all
    select '2022-01-22 13:13:00',926.0,24
    union all
    select '2022-01-22 13:34:00',374.0,28
    union all
    select '2022-01-22 14:00:00',762.0,50
    union all
    select '2022-01-22 15:14:00',394.0,36
    union all
    select '2022-01-22 15:25:00',884.0,2
    union all
    select '2022-01-22 15:31:00',238.0,90
    union all
    select '2022-01-22 16:03:00',128.0,86
    union all
    select '2022-01-22 19:43:00',288.0,98
    union all
    select '2022-01-22 19:44:00',808.0,11
    union all
    select '2022-01-22 21:28:00',488.0,48
    union all
    select '2022-01-22 22:02:00',984.0,64
    union all
    select '2022-01-22 22:17:00',120.0,5
    union all
    select '2022-01-23 00:20:00',380.0,26
    union all
    select '2022-01-23 01:12:00',270.0,80
    union all
    select '2022-01-23 02:32:00',422.0,52
    union all
    select '2022-01-23 03:36:00',852.0,47
    union all
    select '2022-01-23 04:08:00',840.0,74
    union all
    select '2022-01-23 04:43:00',282.0,69
    union all
    select '2022-01-23 06:36:00',590.0,36
    union all
    select '2022-01-23 07:49:00',828.0,28
    union all
    select '2022-01-23 08:02:00',346.0,2
    union all
    select '2022-01-23 09:17:00',796.0,49
    union all
    select '2022-01-23 09:48:00',656.0,38
    union all
    select '2022-01-23 09:49:00',120.0,51
    union all
    select '2022-01-23 11:38:00',198.0,29
    union all
    select '2022-01-23 11:39:00',640.0,19
    union all
    select '2022-01-23 11:42:00',968.0,27
    union all
    select '2022-01-23 13:20:00',238.0,22
    union all
    select '2022-01-23 14:23:00',800.0,58
    union all
    select '2022-01-23 15:33:00',940.0,15
    union all
    select '2022-01-23 17:34:00',920.0,15
    union all
    select '2022-01-23 17:46:00',180.0,64
    union all
    select '2022-01-23 18:41:00',826.0,77
    union all
    select '2022-01-23 22:19:00',894.0,67
    union all
    select '2022-01-23 23:48:00',626.0,26
    union all
    select '2022-01-24 00:11:00',406.0,34
    union all
    select '2022-01-24 00:33:00',958.0,56
    union all
    select '2022-01-24 00:48:00',330.0,78
    union all
    select '2022-01-24 01:42:00',350.0,64
    union all
    select '2022-01-24 03:38:00',954.0,53
    union all
    select '2022-01-24 06:11:00',916.0,86
    union all
    select '2022-01-24 08:30:00',834.0,36
    union all
    select '2022-01-24 09:09:00',518.0,80
    union all
    select '2022-01-24 09:36:00',688.0,48
    union all
    select '2022-01-24 09:46:00',352.0,58
    union all
    select '2022-01-24 16:07:00',300.0,51
    union all
    select '2022-01-24 16:29:00',820.0,11
    union all
    select '2022-01-24 17:18:00',286.0,67
    union all
    select '2022-01-24 18:18:00',692.0,79
    union all
    select '2022-01-24 19:12:00',188.0,94
    union all
    select '2022-01-24 19:45:00',168.0,21
    union all
    select '2022-01-24 20:48:00',754.0,44
    union all
    select '2022-01-24 22:19:00',864.0,42
    union all
    select '2022-01-24 22:38:00',378.0,5
    union all
    select '2022-01-24 23:18:00',618.0,50
    union all
    select '2022-01-24 23:53:00',208.0,91
    union all
    select '2022-01-25 00:19:00',206.0,30
    union all
    select '2022-01-25 00:27:00',328.0,71
    union all
    select '2022-01-25 02:24:00',198.0,94
    union all
    select '2022-01-25 05:52:00',680.0,64
    union all
    select '2022-01-25 06:18:00',266.0,78
    union all
    select '2022-01-25 07:02:00',140.0,38
    union all
    select '2022-01-25 09:33:00',104.0,71
    union all
    select '2022-01-25 09:43:00',718.0,78
    union all
    select '2022-01-25 11:20:00',650.0,18
    union all
    select '2022-01-25 11:30:00',900.0,60
    union all
    select '2022-01-25 11:50:00',702.0,36
    union all
    select '2022-01-25 13:26:00',704.0,45
    union all
    select '2022-01-25 13:26:00',198.0,62
    union all
    select '2022-01-25 14:55:00',484.0,7
    union all
    select '2022-01-25 16:18:00',594.0,59
    union all
    select '2022-01-25 18:13:00',496.0,18
    union all
    select '2022-01-25 19:15:00',244.0,79
    union all
    select '2022-01-25 21:58:00',238.0,98
    union all
    select '2022-01-25 23:31:00',480.0,87
    union all
    select '2022-01-25 23:54:00',668.0,18
    union all
    select '2022-01-26 03:10:00',792.0,72
    union all
    select '2022-01-26 03:58:00',684.0,55
    union all
    select '2022-01-26 04:58:00',756.0,82
    union all
    select '2022-01-26 06:58:00',804.0,43
    union all
    select '2022-01-26 07:23:00',550.0,87
    union all
    select '2022-01-26 07:25:00',236.0,35
    union all
    select '2022-01-26 10:52:00',970.0,71
    union all
    select '2022-01-26 10:52:00',196.0,99
    union all
    select '2022-01-26 11:36:00',650.0,50
    union all
    select '2022-01-26 12:29:00',158.0,65
    union all
    select '2022-01-26 12:55:00',536.0,21
    union all
    select '2022-01-26 13:39:00',350.0,43
    union all
    select '2022-01-26 13:39:00',688.0,92
    union all
    select '2022-01-26 14:11:00',448.0,43
    union all
    select '2022-01-26 16:32:00',996.0,61
    union all
    select '2022-01-26 16:41:00',490.0,74
    union all
    select '2022-01-26 16:59:00',670.0,64
    union all
    select '2022-01-26 18:04:00',146.0,49
    union all
    select '2022-01-26 21:09:00',760.0,77
    union all
    select '2022-01-26 21:28:00',164.0,91
    union all
    select '2022-01-26 21:57:00',870.0,39
    union all
    select '2022-01-27 00:16:00',990.0,12
    union all
    select '2022-01-27 01:56:00',178.0,28
    union all
    select '2022-01-27 02:11:00',750.0,75
    union all
    select '2022-01-27 03:18:00',464.0,32
    union all
    select '2022-01-27 04:02:00',686.0,70
    union all
    select '2022-01-27 04:39:00',882.0,32
    union all
    select '2022-01-27 04:59:00',804.0,10
    union all
    select '2022-01-27 05:08:00',718.0,84
    union all
    select '2022-01-27 05:20:00',800.0,95
    union all
    select '2022-01-27 06:46:00',326.0,75
    union all
    select '2022-01-27 06:50:00',208.0,8
    union all
    select '2022-01-27 06:50:00',664.0,21
    union all
    select '2022-01-27 07:48:00',870.0,88
    union all
    select '2022-01-27 07:53:00',402.0,7
    union all
    select '2022-01-27 08:38:00',746.0,80
    union all
    select '2022-01-27 08:47:00',308.0,88
    union all
    select '2022-01-27 10:02:00',178.0,23
    union all
    select '2022-01-27 10:28:00',358.0,95
    union all
    select '2022-01-27 12:08:00',394.0,62
    union all
    select '2022-01-27 12:50:00',412.0,58
    union all
    select '2022-01-27 12:56:00',230.0,55
    union all
    select '2022-01-27 15:15:00',222.0,46
    union all
    select '2022-01-27 15:16:00',476.0,53
    union all
    select '2022-01-27 16:08:00',772.0,94
    union all
    select '2022-01-27 16:28:00',912.0,42
    union all
    select '2022-01-27 16:47:00',950.0,71
    union all
    select '2022-01-27 17:10:00',450.0,41
    union all
    select '2022-01-27 18:11:00',596.0,56
    union all
    select '2022-01-27 19:00:00',712.0,57
    union all
    select '2022-01-27 19:17:00',174.0,97
    union all
    select '2022-01-27 22:43:00',892.0,58
    union all
    select '2022-01-28 00:04:00',834.0,99
    union all
    select '2022-01-28 00:13:00',540.0,23
    union all
    select '2022-01-28 01:30:00',674.0,52
    union all
    select '2022-01-28 01:48:00',526.0,77
    union all
    select '2022-01-28 05:18:00',728.0,10
    union all
    select '2022-01-28 06:47:00',412.0,81
    union all
    select '2022-01-28 07:45:00',510.0,30
    union all
    select '2022-01-28 09:00:00',884.0,6
    union all
    select '2022-01-28 09:13:00',628.0,86
    union all
    select '2022-01-28 09:37:00',606.0,35
    union all
    select '2022-01-28 11:48:00',686.0,90
    union all
    select '2022-01-28 13:04:00',582.0,2
    union all
    select '2022-01-28 15:06:00',694.0,24
    union all
    select '2022-01-28 15:21:00',750.0,94
    union all
    select '2022-01-28 15:28:00',732.0,27
    union all
    select '2022-01-28 19:09:00',880.0,36
    union all
    select '2022-01-28 19:11:00',662.0,79
    union all
    select '2022-01-28 20:37:00',400.0,32
    union all
    select '2022-01-28 21:43:00',648.0,63
    union all
    select '2022-01-28 23:57:00',138.0,29
    union all
    select '2022-01-29 00:19:00',522.0,5
    union all
    select '2022-01-29 01:47:00',750.0,85
    union all
    select '2022-01-29 02:25:00',228.0,83
    union all
    select '2022-01-29 04:00:00',228.0,8
    union all
    select '2022-01-29 06:54:00',396.0,40
    union all
    select '2022-01-29 07:51:00',970.0,77
    union all
    select '2022-01-29 08:40:00',956.0,88
    union all
    select '2022-01-29 09:50:00',148.0,2
    union all
    select '2022-01-29 10:03:00',354.0,46
    union all
    select '2022-01-29 10:06:00',192.0,11
    union all
    select '2022-01-29 10:16:00',654.0,84
    union all
    select '2022-01-29 10:26:00',558.0,72
    union all
    select '2022-01-29 10:45:00',638.0,66
    union all
    select '2022-01-29 11:06:00',580.0,87
    union all
    select '2022-01-29 12:56:00',954.0,42
    union all
    select '2022-01-29 12:57:00',726.0,64
    union all
    select '2022-01-29 14:42:00',600.0,25
    union all
    select '2022-01-29 15:34:00',112.0,19
    union all
    select '2022-01-29 15:38:00',380.0,9
    union all
    select '2022-01-29 16:12:00',246.0,90
    union all
    select '2022-01-29 18:02:00',434.0,93
    union all
    select '2022-01-29 18:52:00',980.0,33
    union all
    select '2022-01-29 19:37:00',884.0,82
    union all
    select '2022-01-29 23:55:00',598.0,43
    union all
    select '2022-01-30 01:42:00',842.0,56
    union all
    select '2022-01-30 04:11:00',182.0,78
    union all
    select '2022-01-30 04:28:00',160.0,77
    union all
    select '2022-01-30 06:20:00',370.0,7
    union all
    select '2022-01-30 06:58:00',770.0,1
    union all
    select '2022-01-30 07:08:00',472.0,77
    union all
    select '2022-01-30 08:51:00',596.0,40
    union all
    select '2022-01-30 09:18:00',598.0,68
    union all
    select '2022-01-30 10:30:00',462.0,11
    union all
    select '2022-01-30 10:33:00',988.0,31
    union all
    select '2022-01-30 11:01:00',262.0,63
    union all
    select '2022-01-30 11:13:00',592.0,97
    union all
    select '2022-01-30 12:02:00',142.0,51
    union all
    select '2022-01-30 14:41:00',966.0,98
    union all
    select '2022-01-30 14:46:00',286.0,52
    union all
    select '2022-01-30 15:06:00',694.0,74
    union all
    select '2022-01-30 17:52:00',244.0,19
    union all
    select '2022-01-30 20:34:00',796.0,17
    union all
    select '2022-01-30 22:47:00',450.0,25
    union all
    select '2022-01-31 01:34:00',170.0,35
    union all
    select '2022-01-31 02:23:00',252.0,55
    union all
    select '2022-01-31 02:55:00',312.0,40
    union all
    select '2022-01-31 03:00:00',316.0,59
    union all
    select '2022-01-31 03:20:00',686.0,71
    union all
    select '2022-01-31 06:11:00',490.0,67
    union all
    select '2022-01-31 06:27:00',352.0,77
    union all
    select '2022-01-31 06:42:00',118.0,23
    union all
    select '2022-01-31 07:16:00',592.0,11
    union all
    select '2022-01-31 08:11:00',346.0,43
    union all
    select '2022-01-31 08:13:00',248.0,13
    union all
    select '2022-01-31 09:48:00',138.0,12
    union all
    select '2022-01-31 09:56:00',930.0,54
    union all
    select '2022-01-31 10:22:00',964.0,62
    union all
    select '2022-01-31 11:40:00',490.0,29
    union all
    select '2022-01-31 11:43:00',112.0,65
    union all
    select '2022-01-31 13:32:00',114.0,39
    union all
    select '2022-01-31 14:17:00',570.0,63
    union all
    select '2022-01-31 16:17:00',564.0,67
    union all
    select '2022-01-31 18:10:00',654.0,84
    union all
    select '2022-01-31 18:34:00',330.0,86
    union all
    select '2022-01-31 18:45:00',198.0,34
    union all
    select '2022-01-31 19:16:00',750.0,66
    union all
    select '2022-01-31 20:52:00',436.0,75
    union all
    select '2022-01-31 20:54:00',288.0,9
    union all
    select '2022-01-31 22:17:00',818.0,79
    union all
    select '2022-01-31 22:26:00',290.0,33
    union all
    select '2022-02-01 00:30:00',598.0,35
    union all
    select '2022-02-01 01:29:00',140.0,11
    union all
    select '2022-02-01 01:42:00',422.0,88
    union all
    select '2022-02-01 02:06:00',430.0,90
    union all
    select '2022-02-01 03:42:00',740.0,43
    union all
    select '2022-02-01 04:16:00',724.0,18
    union all
    select '2022-02-01 05:09:00',600.0,26
    union all
    select '2022-02-01 05:35:00',870.0,12
    union all
    select '2022-02-01 05:54:00',958.0,43
    union all
    select '2022-02-01 06:29:00',258.0,5
    union all
    select '2022-02-01 07:01:00',344.0,44
    union all
    select '2022-02-01 07:18:00',178.0,92
    union all
    select '2022-02-01 07:39:00',310.0,96
    union all
    select '2022-02-01 11:18:00',576.0,17
    union all
    select '2022-02-01 11:45:00',394.0,12
    union all
    select '2022-02-01 13:07:00',614.0,52
    union all
    select '2022-02-01 13:48:00',704.0,97
    union all
    select '2022-02-01 14:10:00',610.0,55
    union all
    select '2022-02-01 17:30:00',848.0,44
    union all
    select '2022-02-01 19:13:00',624.0,81
    union all
    select '2022-02-01 19:22:00',986.0,20
    union all
    select '2022-02-01 19:35:00',806.0,44
    union all
    select '2022-02-01 20:11:00',114.0,45
    union all
    select '2022-02-01 21:39:00',620.0,28
    union all
    select '2022-02-01 22:21:00',670.0,97
    union all
    select '2022-02-01 22:58:00',472.0,69
    union all
    select '2022-02-02 00:06:00',390.0,10
    union all
    select '2022-02-02 00:14:00',950.0,93
    union all
    select '2022-02-02 00:19:00',364.0,69
    union all
    select '2022-02-02 00:35:00',234.0,83
    union all
    select '2022-02-02 00:40:00',578.0,30
    union all
    select '2022-02-02 00:57:00',120.0,64
    union all
    select '2022-02-02 01:23:00',434.0,76
    union all
    select '2022-02-02 01:36:00',188.0,34
    union all
    select '2022-02-02 05:38:00',302.0,83
    union all
    select '2022-02-02 06:45:00',542.0,37
    union all
    select '2022-02-02 07:04:00',658.0,18
    union all
    select '2022-02-02 07:33:00',168.0,23
    union all
    select '2022-02-02 11:16:00',954.0,62
    union all
    select '2022-02-02 11:19:00',946.0,63
    union all
    select '2022-02-02 12:32:00',868.0,3
    union all
    select '2022-02-02 12:52:00',358.0,79
    union all
    select '2022-02-02 14:48:00',106.0,97
    union all
    select '2022-02-02 15:49:00',674.0,56
    union all
    select '2022-02-02 17:21:00',116.0,89
    union all
    select '2022-02-02 17:34:00',686.0,28
    union all
    select '2022-02-02 17:45:00',624.0,66
    union all
    select '2022-02-02 18:43:00',480.0,7
    union all
    select '2022-02-02 20:09:00',338.0,56
    union all
    select '2022-02-02 20:22:00',720.0,41
    union all
    select '2022-02-02 21:04:00',988.0,17
    union all
    select '2022-02-02 21:22:00',306.0,4
    union all
    select '2022-02-03 00:15:00',124.0,88
    union all
    select '2022-02-03 01:06:00',154.0,22
    union all
    select '2022-02-03 01:49:00',708.0,81
    union all
    select '2022-02-03 02:44:00',700.0,76
    union all
    select '2022-02-03 05:43:00',616.0,61
    union all
    select '2022-02-03 06:06:00',834.0,71
    union all
    select '2022-02-03 06:44:00',426.0,5
    union all
    select '2022-02-03 07:12:00',692.0,46
    union all
    select '2022-02-03 08:51:00',864.0,5
    union all
    select '2022-02-03 10:16:00',982.0,78
    union all
    select '2022-02-03 11:47:00',356.0,54
    union all
    select '2022-02-03 13:00:00',388.0,91
    union all
    select '2022-02-03 13:49:00',690.0,99
    union all
    select '2022-02-03 14:20:00',210.0,95
    union all
    select '2022-02-03 16:24:00',476.0,5
    union all
    select '2022-02-03 17:52:00',742.0,28
    union all
    select '2022-02-03 18:31:00',106.0,24
    union all
    select '2022-02-03 21:01:00',610.0,44
    union all
    select '2022-02-03 21:20:00',218.0,74
    union all
    select '2022-02-03 21:34:00',984.0,72
    union all
    select '2022-02-03 22:43:00',946.0,20
    union all
    select '2022-02-04 00:04:00',680.0,7
    union all
    select '2022-02-04 05:25:00',368.0,62
    union all
    select '2022-02-04 07:10:00',328.0,46
    union all
    select '2022-02-04 07:16:00',978.0,91
    union all
    select '2022-02-04 07:52:00',384.0,74
    union all
    select '2022-02-04 09:36:00',998.0,51
    union all
    select '2022-02-04 11:39:00',788.0,38
    union all
    select '2022-02-04 11:46:00',350.0,26
    union all
    select '2022-02-04 12:18:00',388.0,3
    union all
    select '2022-02-04 13:13:00',238.0,85
    union all
    select '2022-02-04 13:22:00',352.0,7
    union all
    select '2022-02-04 14:28:00',926.0,26
    union all
    select '2022-02-04 15:29:00',226.0,16
    union all
    select '2022-02-04 16:28:00',680.0,91
    union all
    select '2022-02-04 16:51:00',270.0,15
    union all
    select '2022-02-04 16:54:00',646.0,89
    union all
    select '2022-02-04 17:39:00',608.0,37
    union all
    select '2022-02-04 17:49:00',824.0,44
    union all
    select '2022-02-04 19:57:00',646.0,12
    union all
    select '2022-02-04 20:15:00',182.0,7
    union all
    select '2022-02-04 20:28:00',268.0,73
    union all
    select '2022-02-04 21:13:00',764.0,7
    union all
    select '2022-02-04 21:46:00',634.0,28
    union all
    select '2022-02-04 23:23:00',318.0,52
    union all
    select '2022-02-05 01:12:00',922.0,91
    union all
    select '2022-02-05 01:26:00',212.0,18
    union all
    select '2022-02-05 02:57:00',802.0,96
    union all
    select '2022-02-05 04:14:00',324.0,84
    union all
    select '2022-02-05 06:00:00',430.0,83
    union all
    select '2022-02-05 06:00:00',986.0,75
    union all
    select '2022-02-05 08:10:00',386.0,26
    union all
    select '2022-02-05 10:12:00',508.0,85
    union all
    select '2022-02-05 11:25:00',174.0,96
    union all
    select '2022-02-05 12:26:00',116.0,12
    union all
    select '2022-02-05 14:20:00',442.0,73
    union all
    select '2022-02-05 18:50:00',752.0,65
    union all
    select '2022-02-05 19:01:00',166.0,35
    union all
    select '2022-02-05 19:05:00',132.0,52
    union all
    select '2022-02-05 20:30:00',220.0,61
    union all
    select '2022-02-05 21:18:00',882.0,54
    union all
    select '2022-02-05 21:37:00',480.0,76
    union all
    select '2022-02-05 23:24:00',736.0,59
    union all
    select '2022-02-06 01:08:00',666.0,44
    union all
    select '2022-02-06 03:14:00',752.0,9
    union all
    select '2022-02-06 03:48:00',884.0,83
    union all
    select '2022-02-06 06:01:00',684.0,85
    union all
    select '2022-02-06 06:36:00',106.0,31
    union all
    select '2022-02-06 07:10:00',614.0,82
    union all
    select '2022-02-06 07:22:00',956.0,17
    union all
    select '2022-02-06 07:22:00',144.0,61
    union all
    select '2022-02-06 08:12:00',920.0,48
    union all
    select '2022-02-06 09:39:00',368.0,73
    union all
    select '2022-02-06 11:11:00',162.0,55
    union all
    select '2022-02-06 13:33:00',502.0,35
    union all
    select '2022-02-06 14:08:00',596.0,22
    union all
    select '2022-02-06 14:20:00',470.0,99
    union all
    select '2022-02-06 14:57:00',650.0,7
    union all
    select '2022-02-06 15:05:00',782.0,37
    union all
    select '2022-02-06 16:03:00',912.0,23
    union all
    select '2022-02-06 17:05:00',596.0,37
    union all
    select '2022-02-06 17:31:00',554.0,68
    union all
    select '2022-02-06 18:31:00',292.0,81
    union all
    select '2022-02-06 19:49:00',564.0,15
    union all
    select '2022-02-06 23:42:00',266.0,16
    union all
    select '2022-02-07 05:44:00',320.0,19
    union all
    select '2022-02-07 07:42:00',592.0,28
    union all
    select '2022-02-07 09:39:00',640.0,13
    union all
    select '2022-02-07 10:28:00',300.0,88
    union all
    select '2022-02-07 11:06:00',344.0,57
    union all
    select '2022-02-07 11:23:00',392.0,11
    union all
    select '2022-02-07 11:29:00',484.0,81
    union all
    select '2022-02-07 11:49:00',602.0,66
    union all
    select '2022-02-07 12:51:00',366.0,33
    union all
    select '2022-02-07 13:04:00',246.0,53
    union all
    select '2022-02-07 14:27:00',886.0,95
    union all
    select '2022-02-07 14:33:00',228.0,71
    union all
    select '2022-02-07 16:00:00',886.0,83
    union all
    select '2022-02-07 16:09:00',822.0,50
    union all
    select '2022-02-07 16:23:00',536.0,74
    union all
    select '2022-02-07 19:38:00',838.0,99
    union all
    select '2022-02-07 20:34:00',290.0,94
    union all
    select '2022-02-07 23:00:00',860.0,54
    union all
    select '2022-02-07 23:29:00',454.0,30
    union all
    select '2022-02-08 00:07:00',496.0,19
    union all
    select '2022-02-08 00:34:00',370.0,18
    union all
    select '2022-02-08 00:47:00',716.0,29
    union all
    select '2022-02-08 01:03:00',426.0,50
    union all
    select '2022-02-08 02:35:00',594.0,37
    union all
    select '2022-02-08 05:58:00',176.0,41
    union all
    select '2022-02-08 07:15:00',398.0,52
    union all
    select '2022-02-08 07:27:00',994.0,44
    union all
    select '2022-02-08 09:05:00',970.0,96
    union all
    select '2022-02-08 09:30:00',248.0,53
    union all
    select '2022-02-08 09:31:00',934.0,77
    union all
    select '2022-02-08 09:51:00',158.0,6
    union all
    select '2022-02-08 10:29:00',680.0,80
    union all
    select '2022-02-08 12:49:00',702.0,90
    union all
    select '2022-02-08 13:58:00',898.0,66
    union all
    select '2022-02-08 14:27:00',712.0,58
    union all
    select '2022-02-08 16:16:00',528.0,42
    union all
    select '2022-02-08 16:34:00',718.0,77
    union all
    select '2022-02-08 16:43:00',476.0,55
    union all
    select '2022-02-08 17:26:00',842.0,67
    union all
    select '2022-02-08 18:12:00',712.0,15
    union all
    select '2022-02-08 19:23:00',112.0,81
    union all
    select '2022-02-08 19:43:00',164.0,17
    union all
    select '2022-02-08 20:29:00',958.0,57
    union all
    select '2022-02-08 21:54:00',994.0,75
    union all
    select '2022-02-08 22:43:00',970.0,93
    union all
    select '2022-02-08 22:51:00',622.0,38
    union all
    select '2022-02-08 22:53:00',656.0,25
    union all
    select '2022-02-08 22:58:00',356.0,99
    union all
    select '2022-02-08 23:05:00',944.0,94
    union all
    select '2022-02-08 23:44:00',360.0,11
    union all
    select '2022-02-09 02:03:00',322.0,68
    union all
    select '2022-02-09 02:22:00',810.0,10
    union all
    select '2022-02-09 02:23:00',102.0,47
    union all
    select '2022-02-09 05:22:00',988.0,8
    union all
    select '2022-02-09 05:32:00',536.0,93
    union all
    select '2022-02-09 08:28:00',586.0,41
    union all
    select '2022-02-09 09:34:00',546.0,46
    union all
    select '2022-02-09 09:51:00',172.0,44
    union all
    select '2022-02-09 09:59:00',930.0,63
    union all
    select '2022-02-09 10:48:00',952.0,9
    union all
    select '2022-02-09 15:01:00',682.0,41
    union all
    select '2022-02-09 17:29:00',346.0,53
    union all
    select '2022-02-09 17:46:00',960.0,71
    union all
    select '2022-02-09 18:16:00',236.0,44
    union all
    select '2022-02-09 18:45:00',608.0,83
    union all
    select '2022-02-09 20:33:00',616.0,46
    union all
    select '2022-02-09 21:19:00',570.0,10
    union all
    select '2022-02-09 21:26:00',324.0,70
    union all
    select '2022-02-09 21:44:00',376.0,45
    union all
    select '2022-02-09 23:48:00',902.0,19
    union all
    select '2022-02-10 00:06:00',536.0,44
    union all
    select '2022-02-10 02:41:00',776.0,96
    union all
    select '2022-02-10 03:07:00',998.0,90
    union all
    select '2022-02-10 04:55:00',354.0,28
    union all
    select '2022-02-10 07:44:00',334.0,67
    union all
    select '2022-02-10 08:52:00',446.0,42
    union all
    select '2022-02-10 10:08:00',756.0,33
    union all
    select '2022-02-10 11:01:00',614.0,92
    union all
    select '2022-02-10 12:03:00',222.0,82
    union all
    select '2022-02-10 14:27:00',540.0,99
    union all
    select '2022-02-10 14:30:00',452.0,12
    union all
    select '2022-02-10 14:41:00',260.0,35
    union all
    select '2022-02-10 16:25:00',360.0,28
    union all
    select '2022-02-10 18:41:00',328.0,30
    union all
    select '2022-02-10 18:44:00',258.0,86
    union all
    select '2022-02-10 19:00:00',440.0,91
    union all
    select '2022-02-10 19:05:00',870.0,24
    union all
    select '2022-02-10 19:14:00',350.0,21
    union all
    select '2022-02-10 21:42:00',122.0,99
    union all
    select '2022-02-10 22:10:00',422.0,95
    union all
    select '2022-02-10 22:40:00',778.0,75
    union all
    select '2022-02-10 23:22:00',640.0,36
    union all
    select '2022-02-11 00:57:00',818.0,5
    union all
    select '2022-02-11 02:58:00',146.0,72
    union all
    select '2022-02-11 04:09:00',998.0,73
    union all
    select '2022-02-11 05:43:00',944.0,2
    union all
    select '2022-02-11 05:44:00',456.0,75
    union all
    select '2022-02-11 08:47:00',126.0,98
    union all
    select '2022-02-11 10:21:00',190.0,74
    union all
    select '2022-02-11 10:47:00',250.0,21
    union all
    select '2022-02-11 10:53:00',178.0,21
    union all
    select '2022-02-11 12:57:00',546.0,92
    union all
    select '2022-02-11 13:17:00',832.0,8
    union all
    select '2022-02-11 16:59:00',150.0,11
    union all
    select '2022-02-11 21:42:00',826.0,25
    union all
    select '2022-02-12 01:23:00',432.0,31
    union all
    select '2022-02-12 01:55:00',340.0,95
    union all
    select '2022-02-12 03:13:00',840.0,74
    union all
    select '2022-02-12 03:23:00',268.0,14
    union all
    select '2022-02-12 07:10:00',340.0,44
    union all
    select '2022-02-12 07:17:00',622.0,45
    union all
    select '2022-02-12 07:50:00',272.0,86
    union all
    select '2022-02-12 08:29:00',986.0,27
    union all
    select '2022-02-12 08:40:00',720.0,39
    union all
    select '2022-02-12 10:05:00',666.0,53
    union all
    select '2022-02-12 11:15:00',994.0,47
    union all
    select '2022-02-12 12:00:00',782.0,20
    union all
    select '2022-02-12 12:27:00',138.0,92
    union all
    select '2022-02-12 13:20:00',654.0,26
    union all
    select '2022-02-12 13:29:00',986.0,82
    union all
    select '2022-02-12 13:44:00',468.0,51
    union all
    select '2022-02-12 14:31:00',508.0,38
    union all
    select '2022-02-12 15:48:00',558.0,2
    union all
    select '2022-02-12 18:09:00',238.0,61
    union all
    select '2022-02-12 18:31:00',312.0,72
    union all
    select '2022-02-12 19:03:00',102.0,86
    union all
    select '2022-02-12 19:14:00',118.0,79
    union all
    select '2022-02-12 20:39:00',528.0,53
    union all
    select '2022-02-12 23:04:00',336.0,99
    union all
    select '2022-02-12 23:42:00',108.0,83
    union all
    select '2022-02-13 01:12:00',928.0,20
    union all
    select '2022-02-13 01:39:00',852.0,3
    union all
    select '2022-02-13 03:03:00',320.0,62
    union all
    select '2022-02-13 04:30:00',498.0,7
    union all
    select '2022-02-13 04:49:00',684.0,99
    union all
    select '2022-02-13 05:20:00',594.0,92
    union all
    select '2022-02-13 07:11:00',524.0,24
    union all
    select '2022-02-13 08:56:00',696.0,73
    union all
    select '2022-02-13 10:26:00',618.0,13
    union all
    select '2022-02-13 10:35:00',750.0,46
    union all
    select '2022-02-13 10:46:00',286.0,38
    union all
    select '2022-02-13 11:38:00',850.0,34
    union all
    select '2022-02-13 12:41:00',710.0,22
    union all
    select '2022-02-13 13:52:00',920.0,40
    union all
    select '2022-02-13 15:21:00',828.0,85
    union all
    select '2022-02-13 15:36:00',958.0,89
    union all
    select '2022-02-13 16:43:00',486.0,7
    union all
    select '2022-02-13 17:25:00',930.0,78
    union all
    select '2022-02-13 20:08:00',364.0,32
    union all
    select '2022-02-13 20:12:00',124.0,80
    union all
    select '2022-02-13 20:51:00',570.0,55
    union all
    select '2022-02-13 23:36:00',906.0,71
    union all
    select '2022-02-14 01:22:00',268.0,94
    union all
    select '2022-02-14 02:19:00',516.0,24
    union all
    select '2022-02-14 02:51:00',928.0,70
    union all
    select '2022-02-14 03:07:00',822.0,13
    union all
    select '2022-02-14 03:12:00',288.0,98
    union all
    select '2022-02-14 03:20:00',510.0,86
    union all
    select '2022-02-14 03:24:00',542.0,36
    union all
    select '2022-02-14 06:54:00',434.0,56
    union all
    select '2022-02-14 09:20:00',704.0,47
    union all
    select '2022-02-14 09:34:00',630.0,23
    union all
    select '2022-02-14 10:38:00',732.0,35
    union all
    select '2022-02-14 10:52:00',962.0,58
    union all
    select '2022-02-14 11:17:00',146.0,46
    union all
    select '2022-02-14 11:31:00',648.0,46
    union all
    select '2022-02-14 13:46:00',570.0,70
    union all
    select '2022-02-14 15:19:00',762.0,31
    union all
    select '2022-02-14 17:30:00',304.0,16
    union all
    select '2022-02-14 17:47:00',750.0,62
    union all
    select '2022-02-14 18:19:00',122.0,59
    union all
    select '2022-02-14 19:32:00',256.0,4
    union all
    select '2022-02-14 19:38:00',352.0,77
    union all
    select '2022-02-14 20:54:00',588.0,20
    union all
    select '2022-02-14 23:18:00',832.0,16
    union all
    select '2022-02-15 00:07:00',166.0,63
    union all
    select '2022-02-15 00:10:00',396.0,44
    union all
    select '2022-02-15 01:28:00',706.0,89
    union all
    select '2022-02-15 01:37:00',582.0,26
    union all
    select '2022-02-15 01:48:00',424.0,76
    union all
    select '2022-02-15 02:34:00',902.0,51
    union all
    select '2022-02-15 05:38:00',256.0,67
    union all
    select '2022-02-15 05:42:00',616.0,11
    union all
    select '2022-02-15 06:03:00',368.0,8
    union all
    select '2022-02-15 07:00:00',654.0,45
    union all
    select '2022-02-15 09:08:00',650.0,98
    union all
    select '2022-02-15 10:56:00',422.0,33
    union all
    select '2022-02-15 11:10:00',854.0,4
    union all
    select '2022-02-15 11:33:00',986.0,93
    union all
    select '2022-02-15 11:51:00',506.0,67
    union all
    select '2022-02-15 12:17:00',362.0,34
    union all
    select '2022-02-15 14:01:00',398.0,27
    union all
    select '2022-02-15 16:05:00',576.0,39
    union all
    select '2022-02-15 16:23:00',170.0,88
    union all
    select '2022-02-15 16:33:00',450.0,71
    union all
    select '2022-02-15 17:41:00',538.0,39
    union all
    select '2022-02-15 17:42:00',666.0,35
    union all
    select '2022-02-15 18:51:00',600.0,68
    union all
    select '2022-02-15 19:42:00',762.0,77
    union all
    select '2022-02-15 22:05:00',534.0,42
    union all
    select '2022-02-15 22:28:00',258.0,24
    union all
    select '2022-02-16 02:03:00',968.0,38
    union all
    select '2022-02-16 02:22:00',728.0,69
    union all
    select '2022-02-16 03:05:00',250.0,46
    union all
    select '2022-02-16 03:06:00',802.0,5
    union all
    select '2022-02-16 04:30:00',550.0,2
    union all
    select '2022-02-16 04:35:00',584.0,82
    union all
    select '2022-02-16 05:44:00',676.0,10
    union all
    select '2022-02-16 08:32:00',834.0,4
    union all
    select '2022-02-16 08:33:00',488.0,34
    union all
    select '2022-02-16 08:41:00',148.0,1
    union all
    select '2022-02-16 09:56:00',148.0,24
    union all
    select '2022-02-16 11:31:00',364.0,99
    union all
    select '2022-02-16 15:26:00',810.0,91
    union all
    select '2022-02-16 15:33:00',870.0,76
    union all
    select '2022-02-16 15:37:00',730.0,33
    union all
    select '2022-02-16 16:15:00',764.0,27
    union all
    select '2022-02-16 16:31:00',690.0,54
    union all
    select '2022-02-16 18:57:00',328.0,6
    union all
    select '2022-02-16 21:32:00',316.0,1
    union all
    select '2022-02-16 23:08:00',164.0,59
    union all
    select '2022-02-17 00:05:00',216.0,59
    union all
    select '2022-02-17 00:42:00',848.0,39
    union all
    select '2022-02-17 01:07:00',180.0,98
    union all
    select '2022-02-17 02:22:00',606.0,36
    union all
    select '2022-02-17 03:19:00',392.0,25
    union all
    select '2022-02-17 04:35:00',776.0,98
    union all
    select '2022-02-17 05:47:00',476.0,93
    union all
    select '2022-02-17 06:13:00',724.0,8
    union all
    select '2022-02-17 07:49:00',120.0,65
    union all
    select '2022-02-17 10:01:00',386.0,64
    union all
    select '2022-02-17 10:29:00',202.0,27
    union all
    select '2022-02-17 11:16:00',954.0,23
    union all
    select '2022-02-17 12:32:00',934.0,21
    union all
    select '2022-02-17 12:41:00',316.0,43
    union all
    select '2022-02-17 13:06:00',976.0,94
    union all
    select '2022-02-17 13:37:00',430.0,63
    union all
    select '2022-02-17 14:09:00',470.0,43
    union all
    select '2022-02-17 16:45:00',898.0,13
    union all
    select '2022-02-17 19:19:00',988.0,51
    union all
    select '2022-02-17 21:07:00',858.0,51
    union all
    select '2022-02-17 21:53:00',682.0,96
    union all
    select '2022-02-17 22:50:00',906.0,67
    union all
    select '2022-02-17 23:12:00',724.0,74
    union all
    select '2022-02-17 23:16:00',206.0,56
    union all
    select '2022-02-18 02:23:00',962.0,28
    union all
    select '2022-02-18 03:10:00',970.0,30
    union all
    select '2022-02-18 05:35:00',982.0,18
    union all
    select '2022-02-18 05:43:00',100.0,10
    union all
    select '2022-02-18 05:53:00',526.0,94
    union all
    select '2022-02-18 07:17:00',622.0,27
    union all
    select '2022-02-18 10:50:00',592.0,90
    union all
    select '2022-02-18 11:46:00',492.0,70
    union all
    select '2022-02-18 12:05:00',206.0,16
    union all
    select '2022-02-18 12:27:00',922.0,80
    union all
    select '2022-02-18 12:55:00',546.0,4
    union all
    select '2022-02-18 14:45:00',540.0,43
    union all
    select '2022-02-18 16:41:00',212.0,63
    union all
    select '2022-02-18 16:51:00',914.0,17
    union all
    select '2022-02-18 17:16:00',674.0,78
    union all
    select '2022-02-18 17:39:00',316.0,57
    union all
    select '2022-02-18 17:55:00',852.0,35
    union all
    select '2022-02-18 17:59:00',434.0,31
    union all
    select '2022-02-18 19:01:00',318.0,82
    union all
    select '2022-02-18 19:40:00',586.0,27
    union all
    select '2022-02-18 20:34:00',204.0,94
    union all
    select '2022-02-18 20:54:00',418.0,8
    union all
    select '2022-02-18 21:07:00',100.0,66
    union all
    select '2022-02-18 22:47:00',368.0,18
    union all
    select '2022-02-19 00:26:00',214.0,3
    union all
    select '2022-02-19 01:44:00',962.0,76
    union all
    select '2022-02-19 03:02:00',968.0,59
    union all
    select '2022-02-19 04:10:00',436.0,11
    union all
    select '2022-02-19 04:28:00',470.0,22
    union all
    select '2022-02-19 04:41:00',542.0,46
    union all
    select '2022-02-19 05:44:00',864.0,94
    union all
    select '2022-02-19 06:42:00',922.0,11
    union all
    select '2022-02-19 07:01:00',850.0,67
    union all
    select '2022-02-19 07:27:00',522.0,29
    union all
    select '2022-02-19 11:28:00',878.0,8
    union all
    select '2022-02-19 12:46:00',304.0,33
    union all
    select '2022-02-19 12:56:00',698.0,20
    union all
    select '2022-02-19 13:12:00',998.0,19
    union all
    select '2022-02-19 13:52:00',748.0,1
    union all
    select '2022-02-19 13:57:00',824.0,98
    union all
    select '2022-02-19 19:27:00',980.0,78
    union all
    select '2022-02-19 21:41:00',606.0,27
    union all
    select '2022-02-19 21:45:00',542.0,95
    union all
    select '2022-02-19 22:57:00',730.0,23
    union all
    select '2022-02-19 23:29:00',220.0,89
    union all
    select '2022-02-19 23:46:00',128.0,68
    union all
    select '2022-02-20 01:44:00',920.0,94
    union all
    select '2022-02-20 03:09:00',686.0,41
    union all
    select '2022-02-20 03:38:00',952.0,54
    union all
    select '2022-02-20 03:42:00',288.0,17
    union all
    select '2022-02-20 03:59:00',544.0,56
    union all
    select '2022-02-20 05:08:00',796.0,78
    union all
    select '2022-02-20 05:22:00',894.0,75
    union all
    select '2022-02-20 05:43:00',740.0,23
    union all
    select '2022-02-20 05:46:00',800.0,23
    union all
    select '2022-02-20 06:04:00',988.0,10
    union all
    select '2022-02-20 07:58:00',990.0,49
    union all
    select '2022-02-20 08:17:00',990.0,40
    union all
    select '2022-02-20 09:21:00',608.0,13
    union all
    select '2022-02-20 11:31:00',606.0,69
    union all
    select '2022-02-20 12:05:00',100.0,68
    union all
    select '2022-02-20 13:12:00',108.0,9
    union all
    select '2022-02-20 13:39:00',888.0,98
    union all
    select '2022-02-20 14:28:00',220.0,36
    union all
    select '2022-02-20 15:16:00',554.0,54
    union all
    select '2022-02-20 16:46:00',736.0,33
    union all
    select '2022-02-20 17:27:00',838.0,48
    union all
    select '2022-02-20 20:50:00',340.0,25
    union all
    select '2022-02-20 21:10:00',310.0,72
    union all
    select '2022-02-20 23:53:00',182.0,19
    union all
    select '2022-02-21 00:11:00',728.0,62
    union all
    select '2022-02-21 00:35:00',450.0,6
    union all
    select '2022-02-21 00:49:00',926.0,89
    union all
    select '2022-02-21 01:13:00',830.0,15
    union all
    select '2022-02-21 03:20:00',920.0,38
    union all
    select '2022-02-21 03:46:00',836.0,48
    union all
    select '2022-02-21 04:04:00',848.0,27
    union all
    select '2022-02-21 04:04:00',416.0,26
    union all
    select '2022-02-21 04:38:00',186.0,13
    union all
    select '2022-02-21 04:43:00',238.0,94
    union all
    select '2022-02-21 07:22:00',360.0,30
    union all
    select '2022-02-21 09:04:00',470.0,53
    union all
    select '2022-02-21 09:51:00',214.0,79
    union all
    select '2022-02-21 10:14:00',398.0,38
    union all
    select '2022-02-21 12:38:00',568.0,70
    union all
    select '2022-02-21 15:20:00',628.0,62
    union all
    select '2022-02-21 16:04:00',500.0,52
    union all
    select '2022-02-21 17:22:00',922.0,61
    union all
    select '2022-02-21 17:56:00',486.0,37
    union all
    select '2022-02-21 18:18:00',742.0,73
    union all
    select '2022-02-21 20:44:00',190.0,56
    union all
    select '2022-02-21 21:04:00',860.0,69
    union all
    select '2022-02-21 21:16:00',750.0,73
    union all
    select '2022-02-21 21:51:00',170.0,80
    union all
    select '2022-02-21 22:17:00',108.0,21
    union all
    select '2022-02-21 22:36:00',580.0,35
    union all
    select '2022-02-21 22:44:00',380.0,85
    union all
    select '2022-02-21 22:56:00',874.0,41
    union all
    select '2022-02-21 23:32:00',782.0,68
    union all
    select '2022-02-22 00:04:00',144.0,34
    union all
    select '2022-02-22 03:19:00',500.0,58
    union all
    select '2022-02-22 03:34:00',418.0,75
    union all
    select '2022-02-22 03:39:00',694.0,88
    union all
    select '2022-02-22 04:09:00',568.0,29
    union all
    select '2022-02-22 04:12:00',212.0,62
    union all
    select '2022-02-22 05:11:00',728.0,99
    union all
    select '2022-02-22 05:38:00',444.0,27
    union all
    select '2022-02-22 06:58:00',248.0,10
    union all
    select '2022-02-22 08:07:00',466.0,27
    union all
    select '2022-02-22 08:09:00',716.0,79
    union all
    select '2022-02-22 08:31:00',770.0,51
    union all
    select '2022-02-22 08:40:00',208.0,13
    union all
    select '2022-02-22 09:37:00',522.0,29
    union all
    select '2022-02-22 10:49:00',950.0,79
    union all
    select '2022-02-22 11:22:00',788.0,57
    union all
    select '2022-02-22 11:54:00',654.0,4
    union all
    select '2022-02-22 12:16:00',860.0,94
    union all
    select '2022-02-22 13:01:00',332.0,26
    union all
    select '2022-02-22 13:03:00',240.0,48
    union all
    select '2022-02-22 14:11:00',222.0,89
    union all
    select '2022-02-22 14:14:00',706.0,72
    union all
    select '2022-02-22 14:33:00',184.0,15
    union all
    select '2022-02-22 16:58:00',142.0,20
    union all
    select '2022-02-22 17:29:00',916.0,92
    union all
    select '2022-02-22 18:40:00',868.0,3
    union all
    select '2022-02-22 19:09:00',912.0,93
    union all
    select '2022-02-22 19:38:00',954.0,50
    union all
    select '2022-02-22 20:14:00',932.0,7
    union all
    select '2022-02-22 20:16:00',876.0,36
    union all
    select '2022-02-22 21:48:00',268.0,44
    union all
    select '2022-02-22 22:39:00',988.0,57
    union all
    select '2022-02-22 23:04:00',206.0,75
    union all
    select '2022-02-22 23:11:00',264.0,55
    union all
    select '2022-02-22 23:19:00',526.0,90
    union all
    select '2022-02-23 00:43:00',480.0,52
    union all
    select '2022-02-23 01:35:00',866.0,98
    union all
    select '2022-02-23 01:45:00',208.0,62
    union all
    select '2022-02-23 03:12:00',258.0,8
    union all
    select '2022-02-23 03:36:00',886.0,68
    union all
    select '2022-02-23 05:03:00',482.0,54
    union all
    select '2022-02-23 05:08:00',150.0,29
    union all
    select '2022-02-23 06:38:00',200.0,41
    union all
    select '2022-02-23 07:39:00',932.0,48
    union all
    select '2022-02-23 10:47:00',832.0,14
    union all
    select '2022-02-23 12:03:00',960.0,41
    union all
    select '2022-02-23 14:14:00',326.0,71
    union all
    select '2022-02-23 14:18:00',198.0,73
    union all
    select '2022-02-23 14:34:00',918.0,53
    union all
    select '2022-02-23 17:09:00',438.0,87
    union all
    select '2022-02-23 17:16:00',176.0,97
    union all
    select '2022-02-23 17:56:00',338.0,35
    union all
    select '2022-02-23 17:59:00',864.0,3
    union all
    select '2022-02-23 18:01:00',168.0,51
    union all
    select '2022-02-23 18:58:00',422.0,87
    union all
    select '2022-02-23 19:54:00',204.0,27
    union all
    select '2022-02-23 20:00:00',778.0,98
    union all
    select '2022-02-23 23:50:00',664.0,88
    union all
    select '2022-02-24 00:09:00',134.0,26
    union all
    select '2022-02-24 00:24:00',974.0,86
    union all
    select '2022-02-24 01:20:00',608.0,44
    union all
    select '2022-02-24 02:11:00',372.0,50
    union all
    select '2022-02-24 03:32:00',644.0,75
    union all
    select '2022-02-24 06:58:00',466.0,17
    union all
    select '2022-02-24 09:57:00',126.0,87
    union all
    select '2022-02-24 10:48:00',312.0,24
    union all
    select '2022-02-24 11:43:00',554.0,98
    union all
    select '2022-02-24 12:49:00',218.0,94
    union all
    select '2022-02-24 13:38:00',370.0,68
    union all
    select '2022-02-24 13:47:00',308.0,19
    union all
    select '2022-02-24 14:38:00',950.0,56
    union all
    select '2022-02-24 14:46:00',802.0,65
    union all
    select '2022-02-24 14:55:00',556.0,37
    union all
    select '2022-02-24 15:50:00',980.0,29
    union all
    select '2022-02-24 16:40:00',804.0,7
    union all
    select '2022-02-24 16:53:00',426.0,40
    union all
    select '2022-02-24 17:33:00',698.0,1
    union all
    select '2022-02-24 18:53:00',966.0,2
    union all
    select '2022-02-24 18:55:00',220.0,72
    union all
    select '2022-02-24 19:25:00',482.0,33
    union all
    select '2022-02-24 20:01:00',412.0,3
    union all
    select '2022-02-24 20:15:00',448.0,23
    union all
    select '2022-02-24 20:50:00',502.0,79
    union all
    select '2022-02-24 23:29:00',416.0,11
    union all
    select '2022-02-25 01:45:00',314.0,80
    union all
    select '2022-02-25 02:06:00',562.0,47
    union all
    select '2022-02-25 02:17:00',444.0,23
    union all
    select '2022-02-25 02:19:00',988.0,2
    union all
    select '2022-02-25 03:50:00',872.0,57
    union all
    select '2022-02-25 04:03:00',102.0,8
    union all
    select '2022-02-25 04:22:00',946.0,80
    union all
    select '2022-02-25 05:15:00',742.0,88
    union all
    select '2022-02-25 05:16:00',480.0,75
    union all
    select '2022-02-25 05:16:00',574.0,43
    union all
    select '2022-02-25 07:36:00',754.0,63
    union all
    select '2022-02-25 07:42:00',594.0,33
    union all
    select '2022-02-25 08:39:00',738.0,67
    union all
    select '2022-02-25 10:23:00',446.0,56
    union all
    select '2022-02-25 10:24:00',756.0,17
    union all
    select '2022-02-25 11:37:00',552.0,53
    union all
    select '2022-02-25 13:09:00',934.0,18
    union all
    select '2022-02-25 13:36:00',522.0,69
    union all
    select '2022-02-25 14:30:00',322.0,17
    union all
    select '2022-02-25 14:46:00',816.0,80
    union all
    select '2022-02-25 16:39:00',510.0,14
    union all
    select '2022-02-25 17:15:00',374.0,77
    union all
    select '2022-02-25 17:21:00',256.0,3
    union all
    select '2022-02-25 18:22:00',834.0,15
    union all
    select '2022-02-25 19:01:00',498.0,42
    union all
    select '2022-02-25 19:18:00',108.0,33
    union all
    select '2022-02-25 19:35:00',496.0,19
    union all
    select '2022-02-25 21:36:00',724.0,65
    union all
    select '2022-02-25 22:50:00',396.0,47
    union all
    select '2022-02-25 23:08:00',358.0,13
    union all
    select '2022-02-26 00:06:00',186.0,19
    union all
    select '2022-02-26 00:06:00',414.0,88
    union all
    select '2022-02-26 01:58:00',164.0,66
    union all
    select '2022-02-26 02:46:00',412.0,85
    union all
    select '2022-02-26 02:58:00',416.0,75
    union all
    select '2022-02-26 07:13:00',122.0,52
    union all
    select '2022-02-26 08:19:00',192.0,87
    union all
    select '2022-02-26 08:22:00',140.0,2
    union all
    select '2022-02-26 08:40:00',668.0,63
    union all
    select '2022-02-26 08:41:00',576.0,62
    union all
    select '2022-02-26 08:55:00',424.0,62
    union all
    select '2022-02-26 10:17:00',248.0,40
    union all
    select '2022-02-26 11:34:00',924.0,61
    union all
    select '2022-02-26 13:03:00',272.0,83
    union all
    select '2022-02-26 14:33:00',914.0,82
    union all
    select '2022-02-26 14:53:00',864.0,36
    union all
    select '2022-02-26 16:51:00',938.0,34
    union all
    select '2022-02-26 17:42:00',510.0,90
    union all
    select '2022-02-26 17:46:00',534.0,2
    union all
    select '2022-02-26 19:36:00',508.0,46
    union all
    select '2022-02-26 22:07:00',390.0,33
    union all
    select '2022-02-26 22:09:00',152.0,73
    union all
    select '2022-02-26 23:24:00',194.0,68
    union all
    select '2022-02-27 01:00:00',936.0,37
    union all
    select '2022-02-27 02:09:00',926.0,15
    union all
    select '2022-02-27 02:12:00',948.0,74
    union all
    select '2022-02-27 03:21:00',334.0,29
    union all
    select '2022-02-27 03:27:00',356.0,54
    union all
    select '2022-02-27 07:07:00',236.0,38
    union all
    select '2022-02-27 09:58:00',258.0,53
    union all
    select '2022-02-27 10:40:00',602.0,78
    union all
    select '2022-02-27 11:59:00',516.0,53
    union all
    select '2022-02-27 12:36:00',782.0,77
    union all
    select '2022-02-27 13:54:00',182.0,90
    union all
    select '2022-02-27 15:45:00',810.0,96
    union all
    select '2022-02-27 16:11:00',812.0,79
    union all
    select '2022-02-27 16:43:00',238.0,86
    union all
    select '2022-02-27 18:04:00',270.0,68
    union all
    select '2022-02-27 18:26:00',748.0,22
    union all
    select '2022-02-27 19:29:00',598.0,25
    union all
    select '2022-02-27 19:36:00',244.0,77
    union all
    select '2022-02-27 19:57:00',672.0,7
    union all
    select '2022-02-27 21:00:00',442.0,86
    union all
    select '2022-02-27 22:38:00',198.0,48
    union all
    select '2022-02-27 22:56:00',560.0,6
    union all
    select '2022-02-28 00:39:00',900.0,27
    union all
    select '2022-02-28 01:30:00',834.0,99
    union all
    select '2022-02-28 01:38:00',478.0,66
    union all
    select '2022-02-28 02:07:00',878.0,38
    union all
    select '2022-02-28 06:08:00',706.0,9
    union all
    select '2022-02-28 07:22:00',912.0,81
    union all
    select '2022-02-28 11:28:00',406.0,4
    union all
    select '2022-02-28 13:04:00',672.0,26
    union all
    select '2022-02-28 13:18:00',570.0,61
    union all
    select '2022-02-28 13:19:00',338.0,20
    union all
    select '2022-02-28 14:48:00',510.0,55
    union all
    select '2022-02-28 16:59:00',822.0,58
    union all
    select '2022-02-28 18:00:00',232.0,25
    union all
    select '2022-02-28 18:25:00',588.0,10
    union all
    select '2022-02-28 18:43:00',828.0,33
    union all
    select '2022-02-28 19:27:00',562.0,94
    union all
    select '2022-02-28 19:34:00',214.0,34
    union all
    select '2022-02-28 21:08:00',732.0,78
    union all
    select '2022-02-28 22:21:00',966.0,79
    union all
    select '2022-03-01 00:57:00',390.0,94
    union all
    select '2022-03-01 01:52:00',192.0,62
    union all
    select '2022-03-01 02:49:00',520.0,76
    union all
    select '2022-03-01 02:57:00',132.0,76
    union all
    select '2022-03-01 03:50:00',282.0,1
    union all
    select '2022-03-01 03:55:00',586.0,5
    union all
    select '2022-03-01 04:29:00',314.0,42
    union all
    select '2022-03-01 05:50:00',520.0,62
    union all
    select '2022-03-01 05:55:00',834.0,80
    union all
    select '2022-03-01 08:55:00',272.0,92
    union all
    select '2022-03-01 08:56:00',738.0,85
    union all
    select '2022-03-01 09:39:00',394.0,57
    union all
    select '2022-03-01 10:44:00',112.0,86
    union all
    select '2022-03-01 10:46:00',980.0,27
    union all
    select '2022-03-01 11:17:00',976.0,22
    union all
    select '2022-03-01 12:19:00',340.0,87
    union all
    select '2022-03-01 12:30:00',778.0,14
    union all
    select '2022-03-01 13:14:00',510.0,18
    union all
    select '2022-03-01 14:20:00',840.0,63
    union all
    select '2022-03-01 18:22:00',124.0,44
    union all
    select '2022-03-01 19:22:00',878.0,25
    union all
    select '2022-03-02 02:06:00',724.0,43
    union all
    select '2022-03-02 03:58:00',888.0,43
    union all
    select '2022-03-02 04:47:00',704.0,95
    union all
    select '2022-03-02 05:09:00',492.0,9
    union all
    select '2022-03-02 05:45:00',990.0,78
    union all
    select '2022-03-02 05:58:00',160.0,73
    union all
    select '2022-03-02 06:09:00',324.0,66
    union all
    select '2022-03-02 06:32:00',432.0,91
    union all
    select '2022-03-02 07:10:00',202.0,32
    union all
    select '2022-03-02 07:14:00',484.0,15
    union all
    select '2022-03-02 07:47:00',336.0,17
    union all
    select '2022-03-02 07:51:00',922.0,93
    union all
    select '2022-03-02 09:33:00',654.0,56
    union all
    select '2022-03-02 11:04:00',746.0,45
    union all
    select '2022-03-02 11:18:00',406.0,95
    union all
    select '2022-03-02 11:36:00',348.0,41
    union all
    select '2022-03-02 11:44:00',470.0,26
    union all
    select '2022-03-02 12:09:00',862.0,91
    union all
    select '2022-03-02 12:31:00',524.0,36
    union all
    select '2022-03-02 12:52:00',474.0,20
    union all
    select '2022-03-02 15:36:00',470.0,64
    union all
    select '2022-03-02 15:47:00',674.0,97
    union all
    select '2022-03-02 16:55:00',112.0,96
    union all
    select '2022-03-02 17:24:00',456.0,3
    union all
    select '2022-03-02 20:48:00',954.0,50
    union all
    select '2022-03-03 00:07:00',492.0,21
    union all
    select '2022-03-03 00:32:00',856.0,94
    union all
    select '2022-03-03 00:41:00',504.0,77
    union all
    select '2022-03-03 01:48:00',712.0,74
    union all
    select '2022-03-03 02:11:00',126.0,61
    union all
    select '2022-03-03 02:29:00',920.0,38
    union all
    select '2022-03-03 02:51:00',446.0,54
    union all
    select '2022-03-03 03:00:00',906.0,72
    union all
    select '2022-03-03 04:18:00',918.0,28
    union all
    select '2022-03-03 05:40:00',514.0,78
    union all
    select '2022-03-03 05:56:00',528.0,86
    union all
    select '2022-03-03 05:56:00',410.0,17
    union all
    select '2022-03-03 07:09:00',240.0,15
    union all
    select '2022-03-03 07:12:00',420.0,57
    union all
    select '2022-03-03 07:59:00',304.0,32
    union all
    select '2022-03-03 12:13:00',132.0,85
    union all
    select '2022-03-03 12:51:00',426.0,70
    union all
    select '2022-03-03 12:57:00',724.0,94
    union all
    select '2022-03-03 13:55:00',158.0,33
    union all
    select '2022-03-03 15:05:00',574.0,64
    union all
    select '2022-03-03 15:46:00',564.0,92
    union all
    select '2022-03-03 15:52:00',660.0,37
    union all
    select '2022-03-03 16:25:00',174.0,65
    union all
    select '2022-03-03 16:45:00',708.0,84
    union all
    select '2022-03-03 17:38:00',460.0,93
    union all
    select '2022-03-03 17:48:00',198.0,21
    union all
    select '2022-03-03 18:47:00',706.0,97
    union all
    select '2022-03-03 20:21:00',976.0,31
    union all
    select '2022-03-03 20:27:00',972.0,98
    union all
    select '2022-03-03 20:54:00',638.0,16
    union all
    select '2022-03-03 21:02:00',904.0,91
    union all
    select '2022-03-03 21:18:00',732.0,90
    union all
    select '2022-03-03 22:23:00',124.0,29
    union all
    select '2022-03-03 23:23:00',778.0,15
    union all
    select '2022-03-04 01:08:00',658.0,78
    union all
    select '2022-03-04 03:51:00',534.0,37
    union all
    select '2022-03-04 05:35:00',414.0,73
    union all
    select '2022-03-04 05:56:00',130.0,71
    union all
    select '2022-03-04 07:03:00',434.0,1
    union all
    select '2022-03-04 07:20:00',716.0,30
    union all
    select '2022-03-04 07:34:00',396.0,60
    union all
    select '2022-03-04 08:05:00',620.0,40
    union all
    select '2022-03-04 08:26:00',198.0,25
    union all
    select '2022-03-04 09:14:00',884.0,69
    union all
    select '2022-03-04 10:06:00',348.0,5
    union all
    select '2022-03-04 10:21:00',146.0,58
    union all
    select '2022-03-04 13:21:00',478.0,52
    union all
    select '2022-03-04 14:29:00',358.0,11
    union all
    select '2022-03-04 15:04:00',780.0,64
    union all
    select '2022-03-04 17:48:00',390.0,40
    union all
    select '2022-03-04 18:33:00',638.0,45
    union all
    select '2022-03-04 19:51:00',902.0,30
    union all
    select '2022-03-04 20:09:00',698.0,8
    union all
    select '2022-03-04 21:23:00',888.0,53
    union all
    select '2022-03-04 21:26:00',180.0,55
    union all
    select '2022-03-04 22:09:00',980.0,31
    union all
    select '2022-03-04 23:13:00',470.0,18
    union all
    select '2022-03-05 01:04:00',600.0,19
    union all
    select '2022-03-05 03:45:00',576.0,73
    union all
    select '2022-03-05 04:47:00',740.0,90
    union all
    select '2022-03-05 05:05:00',540.0,23
    union all
    select '2022-03-05 05:55:00',468.0,64
    union all
    select '2022-03-05 06:17:00',338.0,57
    union all
    select '2022-03-05 06:33:00',952.0,24
    union all
    select '2022-03-05 08:47:00',828.0,53
    union all
    select '2022-03-05 08:53:00',650.0,31
    union all
    select '2022-03-05 09:38:00',254.0,32
    union all
    select '2022-03-05 10:35:00',648.0,76
    union all
    select '2022-03-05 10:46:00',896.0,13
    union all
    select '2022-03-05 11:02:00',556.0,5
    union all
    select '2022-03-05 11:19:00',252.0,19
    union all
    select '2022-03-05 12:10:00',874.0,91
    union all
    select '2022-03-05 12:42:00',904.0,39
    union all
    select '2022-03-05 13:21:00',230.0,66
    union all
    select '2022-03-05 13:33:00',592.0,47
    union all
    select '2022-03-05 13:54:00',982.0,7
    union all
    select '2022-03-05 14:38:00',898.0,57
    union all
    select '2022-03-05 14:50:00',988.0,25
    union all
    select '2022-03-05 19:22:00',842.0,86
    union all
    select '2022-03-05 19:25:00',850.0,9
    union all
    select '2022-03-05 19:51:00',964.0,85
    union all
    select '2022-03-05 20:42:00',442.0,32
    union all
    select '2022-03-05 20:47:00',740.0,40
    union all
    select '2022-03-05 22:20:00',126.0,93
    union all
    select '2022-03-05 22:56:00',196.0,19
    union all
    select '2022-03-05 23:11:00',800.0,20
    union all
    select '2022-03-05 23:23:00',908.0,3
    union all
    select '2022-03-05 23:40:00',206.0,78
    union all
    select '2022-03-05 23:59:00',258.0,89
    union all
    select '2022-03-06 03:49:00',458.0,1
    union all
    select '2022-03-06 04:04:00',788.0,80
    union all
    select '2022-03-06 04:59:00',804.0,88
    union all
    select '2022-03-06 05:30:00',232.0,72
    union all
    select '2022-03-06 05:35:00',408.0,57
    union all
    select '2022-03-06 07:00:00',460.0,65
    union all
    select '2022-03-06 07:25:00',480.0,56
    union all
    select '2022-03-06 07:50:00',452.0,22
    union all
    select '2022-03-06 08:11:00',536.0,94
    union all
    select '2022-03-06 08:27:00',186.0,4
    union all
    select '2022-03-06 08:36:00',282.0,14
    union all
    select '2022-03-06 11:08:00',578.0,25
    union all
    select '2022-03-06 12:14:00',820.0,40
    union all
    select '2022-03-06 12:24:00',594.0,56
    union all
    select '2022-03-06 13:25:00',274.0,15
    union all
    select '2022-03-06 13:27:00',428.0,18
    union all
    select '2022-03-06 13:32:00',242.0,14
    union all
    select '2022-03-06 15:09:00',104.0,73
    union all
    select '2022-03-06 15:54:00',372.0,68
    union all
    select '2022-03-06 16:30:00',306.0,14
    union all
    select '2022-03-06 17:00:00',230.0,41
    union all
    select '2022-03-06 17:12:00',670.0,84
    union all
    select '2022-03-06 17:26:00',386.0,37
    union all
    select '2022-03-06 20:09:00',320.0,32
    union all
    select '2022-03-06 20:24:00',390.0,42
    union all
    select '2022-03-06 21:30:00',764.0,93
    union all
    select '2022-03-06 22:57:00',464.0,34
    union all
    select '2022-03-07 00:29:00',294.0,50
    union all
    select '2022-03-07 01:14:00',658.0,89
    union all
    select '2022-03-07 01:37:00',378.0,68
    union all
    select '2022-03-07 01:38:00',732.0,65
    union all
    select '2022-03-07 03:10:00',900.0,73
    union all
    select '2022-03-07 03:18:00',524.0,40
    union all
    select '2022-03-07 05:15:00',714.0,69
    union all
    select '2022-03-07 05:46:00',964.0,77
    union all
    select '2022-03-07 06:26:00',634.0,16
    union all
    select '2022-03-07 06:39:00',890.0,44
    union all
    select '2022-03-07 08:43:00',898.0,92
    union all
    select '2022-03-07 10:27:00',478.0,32
    union all
    select '2022-03-07 11:09:00',250.0,41
    union all
    select '2022-03-07 12:41:00',746.0,89
    union all
    select '2022-03-07 14:08:00',444.0,87
    union all
    select '2022-03-07 15:50:00',506.0,73
    union all
    select '2022-03-07 16:14:00',988.0,8
    union all
    select '2022-03-07 17:07:00',954.0,94
    union all
    select '2022-03-07 18:16:00',584.0,1
    union all
    select '2022-03-07 20:08:00',462.0,15
    union all
    select '2022-03-07 22:12:00',304.0,13
    union all
    select '2022-03-07 23:12:00',600.0,25
    union all
    select '2022-03-07 23:56:00',710.0,3
    union all
    select '2022-03-08 00:02:00',614.0,35
    union all
    select '2022-03-08 06:25:00',934.0,51
    union all
    select '2022-03-08 06:49:00',112.0,30
    union all
    select '2022-03-08 07:09:00',516.0,31
    union all
    select '2022-03-08 07:25:00',400.0,70
    union all
    select '2022-03-08 08:42:00',950.0,73
    union all
    select '2022-03-08 09:19:00',324.0,82
    union all
    select '2022-03-08 10:10:00',488.0,60
    union all
    select '2022-03-08 13:59:00',226.0,3
    union all
    select '2022-03-08 15:53:00',920.0,51
    union all
    select '2022-03-08 17:45:00',856.0,26
    union all
    select '2022-03-08 18:07:00',686.0,75
    union all
    select '2022-03-08 18:50:00',406.0,17
    union all
    select '2022-03-08 20:30:00',358.0,53
    union all
    select '2022-03-08 21:22:00',760.0,41
    union all
    select '2022-03-08 23:02:00',284.0,92
    union all
    select '2022-03-08 23:58:00',794.0,58
    union all
    select '2022-03-09 00:18:00',268.0,6
    union all
    select '2022-03-09 00:20:00',926.0,13
    union all
    select '2022-03-09 00:55:00',312.0,80
    union all
    select '2022-03-09 01:11:00',360.0,13
    union all
    select '2022-03-09 02:09:00',512.0,35
    union all
    select '2022-03-09 04:20:00',368.0,53
    union all
    select '2022-03-09 04:36:00',960.0,58
    union all
    select '2022-03-09 06:17:00',332.0,98
    union all
    select '2022-03-09 06:38:00',850.0,71
    union all
    select '2022-03-09 06:59:00',586.0,41
    union all
    select '2022-03-09 07:43:00',836.0,69
    union all
    select '2022-03-09 08:45:00',416.0,70
    union all
    select '2022-03-09 08:56:00',686.0,4
    union all
    select '2022-03-09 09:20:00',440.0,49
    union all
    select '2022-03-09 09:55:00',518.0,29
    union all
    select '2022-03-09 10:06:00',928.0,65
    union all
    select '2022-03-09 11:14:00',314.0,5
    union all
    select '2022-03-09 12:14:00',562.0,35
    union all
    select '2022-03-09 12:32:00',218.0,20
    union all
    select '2022-03-09 14:04:00',716.0,53
    union all
    select '2022-03-09 17:25:00',524.0,63
    union all
    select '2022-03-09 17:28:00',584.0,45
    union all
    select '2022-03-09 18:10:00',106.0,33
    union all
    select '2022-03-09 18:48:00',806.0,50
    union all
    select '2022-03-09 18:53:00',758.0,35
    union all
    select '2022-03-09 19:26:00',628.0,24
    union all
    select '2022-03-09 23:10:00',426.0,70
    union all
    select '2022-03-09 23:36:00',624.0,23
    union all
    select '2022-03-09 23:47:00',336.0,58
    union all
    select '2022-03-09 23:56:00',578.0,43
    union all
    select '2022-03-10 03:25:00',696.0,2
    union all
    select '2022-03-10 04:47:00',298.0,38
    union all
    select '2022-03-10 05:05:00',732.0,96
    union all
    select '2022-03-10 06:24:00',508.0,42
    union all
    select '2022-03-10 06:36:00',986.0,98
    union all
    select '2022-03-10 06:40:00',884.0,19
    union all
    select '2022-03-10 07:44:00',478.0,56
    union all
    select '2022-03-10 08:07:00',590.0,50
    union all
    select '2022-03-10 08:45:00',632.0,46
    union all
    select '2022-03-10 09:06:00',870.0,56
    union all
    select '2022-03-10 09:58:00',254.0,33
    union all
    select '2022-03-10 10:13:00',782.0,91
    union all
    select '2022-03-10 12:01:00',164.0,83
    union all
    select '2022-03-10 12:07:00',700.0,42
    union all
    select '2022-03-10 12:21:00',508.0,14
    union all
    select '2022-03-10 12:49:00',246.0,94
    union all
    select '2022-03-10 15:52:00',412.0,73
    union all
    select '2022-03-10 16:30:00',576.0,11
    union all
    select '2022-03-10 17:25:00',268.0,80
    union all
    select '2022-03-10 17:48:00',846.0,52
    union all
    select '2022-03-10 18:24:00',446.0,70
    union all
    select '2022-03-10 18:30:00',274.0,20
    union all
    select '2022-03-10 19:44:00',156.0,22
    union all
    select '2022-03-10 23:14:00',678.0,68
    union all
    select '2022-03-10 23:20:00',884.0,13
    union all
    select '2022-03-10 23:35:00',860.0,32
    union all
    select '2022-03-11 00:29:00',232.0,3
    union all
    select '2022-03-11 02:19:00',474.0,13
    union all
    select '2022-03-11 02:52:00',924.0,71
    union all
    select '2022-03-11 03:40:00',384.0,87
    union all
    select '2022-03-11 04:24:00',782.0,52
    union all
    select '2022-03-11 04:47:00',150.0,25
    union all
    select '2022-03-11 06:24:00',990.0,67
    union all
    select '2022-03-11 08:32:00',152.0,91
    union all
    select '2022-03-11 09:04:00',976.0,84
    union all
    select '2022-03-11 11:19:00',438.0,80
    union all
    select '2022-03-11 11:54:00',948.0,87
    union all
    select '2022-03-11 12:35:00',836.0,49
    union all
    select '2022-03-11 12:59:00',124.0,17
    union all
    select '2022-03-11 17:02:00',528.0,66
    union all
    select '2022-03-11 17:48:00',540.0,77
    union all
    select '2022-03-11 18:29:00',466.0,90
    union all
    select '2022-03-11 19:28:00',814.0,98
    union all
    select '2022-03-11 20:21:00',404.0,16
    union all
    select '2022-03-11 20:51:00',566.0,33
    union all
    select '2022-03-11 22:21:00',740.0,79
    union all
    select '2022-03-11 22:25:00',134.0,90
    union all
    select '2022-03-12 00:53:00',208.0,47
    union all
    select '2022-03-12 01:01:00',244.0,77
    union all
    select '2022-03-12 01:15:00',246.0,7
    union all
    select '2022-03-12 01:48:00',688.0,87
    union all
    select '2022-03-12 03:23:00',766.0,43
    union all
    select '2022-03-12 03:26:00',220.0,92
    union all
    select '2022-03-12 04:33:00',458.0,90
    union all
    select '2022-03-12 05:10:00',930.0,19
    union all
    select '2022-03-12 05:27:00',248.0,20
    union all
    select '2022-03-12 06:22:00',262.0,24
    union all
    select '2022-03-12 07:01:00',196.0,71
    union all
    select '2022-03-12 07:07:00',196.0,78
    union all
    select '2022-03-12 07:39:00',608.0,57
    union all
    select '2022-03-12 08:28:00',112.0,17
    union all
    select '2022-03-12 10:34:00',884.0,7
    union all
    select '2022-03-12 12:35:00',638.0,81
    union all
    select '2022-03-12 12:35:00',744.0,94
    union all
    select '2022-03-12 13:26:00',960.0,91
    union all
    select '2022-03-12 17:15:00',782.0,46
    union all
    select '2022-03-12 17:28:00',554.0,26
    union all
    select '2022-03-12 17:42:00',780.0,12
    union all
    select '2022-03-12 18:19:00',788.0,77
    union all
    select '2022-03-12 19:54:00',408.0,73
    union all
    select '2022-03-12 20:29:00',242.0,8
    union all
    select '2022-03-12 21:20:00',618.0,1
    union all
    select '2022-03-12 21:31:00',324.0,5
    union all
    select '2022-03-12 21:48:00',212.0,33
    union all
    select '2022-03-12 22:04:00',402.0,53
    union all
    select '2022-03-12 22:44:00',432.0,79
    union all
    select '2022-03-12 23:12:00',184.0,10
    union all
    select '2022-03-13 02:44:00',188.0,51
    union all
    select '2022-03-13 03:59:00',208.0,33
    union all
    select '2022-03-13 04:55:00',642.0,52
    union all
    select '2022-03-13 05:48:00',326.0,1
    union all
    select '2022-03-13 08:48:00',830.0,66
    union all
    select '2022-03-13 09:07:00',164.0,45
    union all
    select '2022-03-13 10:16:00',978.0,77
    union all
    select '2022-03-13 11:25:00',162.0,3
    union all
    select '2022-03-13 12:18:00',306.0,52
    union all
    select '2022-03-13 12:43:00',180.0,57
    union all
    select '2022-03-13 12:48:00',462.0,69
    union all
    select '2022-03-13 14:14:00',538.0,80
    union all
    select '2022-03-13 14:20:00',582.0,46
    union all
    select '2022-03-13 14:34:00',388.0,68
    union all
    select '2022-03-13 15:06:00',240.0,16
    union all
    select '2022-03-13 17:01:00',246.0,3
    union all
    select '2022-03-13 18:15:00',492.0,21
    union all
    select '2022-03-13 18:29:00',474.0,45
    union all
    select '2022-03-13 20:09:00',340.0,11
    union all
    select '2022-03-13 20:15:00',282.0,75
    union all
    select '2022-03-13 20:38:00',510.0,91
    union all
    select '2022-03-13 22:03:00',272.0,64
    union all
    select '2022-03-13 23:18:00',832.0,37
    union all
    select '2022-03-14 00:12:00',736.0,73
    union all
    select '2022-03-14 02:44:00',234.0,9
    union all
    select '2022-03-14 04:30:00',350.0,4
    union all
    select '2022-03-14 04:58:00',276.0,16
    union all
    select '2022-03-14 06:51:00',126.0,93
    union all
    select '2022-03-14 09:05:00',658.0,14
    union all
    select '2022-03-14 09:10:00',384.0,64
    union all
    select '2022-03-14 09:24:00',256.0,45
    union all
    select '2022-03-14 09:58:00',446.0,32
    union all
    select '2022-03-14 12:27:00',480.0,84
    union all
    select '2022-03-14 12:45:00',204.0,49
    union all
    select '2022-03-14 12:51:00',304.0,97
    union all
    select '2022-03-14 13:03:00',702.0,95
    union all
    select '2022-03-14 13:59:00',614.0,17
    union all
    select '2022-03-14 14:19:00',524.0,62
    union all
    select '2022-03-14 14:31:00',332.0,27
    union all
    select '2022-03-14 14:41:00',872.0,13
    union all
    select '2022-03-14 16:58:00',966.0,13
    union all
    select '2022-03-14 19:10:00',816.0,24
    union all
    select '2022-03-14 21:02:00',698.0,94
    union all
    select '2022-03-14 21:37:00',470.0,80
    union all
    select '2022-03-14 21:53:00',526.0,14
    union all
    select '2022-03-14 22:34:00',910.0,39
    union all
    select '2022-03-15 01:11:00',172.0,29
    union all
    select '2022-03-15 01:47:00',310.0,90
    union all
    select '2022-03-15 02:27:00',770.0,32
    union all
    select '2022-03-15 02:55:00',128.0,22
    union all
    select '2022-03-15 05:12:00',266.0,22
    union all
    select '2022-03-15 06:30:00',984.0,41
    union all
    select '2022-03-15 07:03:00',250.0,95
    union all
    select '2022-03-15 07:53:00',830.0,62
    union all
    select '2022-03-15 08:05:00',194.0,71
    union all
    select '2022-03-15 09:24:00',470.0,92
    union all
    select '2022-03-15 09:32:00',846.0,5
    union all
    select '2022-03-15 09:47:00',466.0,85
    union all
    select '2022-03-15 10:08:00',298.0,62
    union all
    select '2022-03-15 11:15:00',284.0,34
    union all
    select '2022-03-15 11:22:00',758.0,61
    union all
    select '2022-03-15 12:26:00',570.0,18
    union all
    select '2022-03-15 12:44:00',212.0,75
    union all
    select '2022-03-15 16:00:00',708.0,19
    union all
    select '2022-03-15 19:58:00',570.0,20
    union all
    select '2022-03-15 21:08:00',624.0,39
    union all
    select '2022-03-16 03:28:00',324.0,81
    union all
    select '2022-03-16 04:42:00',884.0,57
    union all
    select '2022-03-16 05:53:00',458.0,83
    union all
    select '2022-03-16 06:53:00',612.0,90
    union all
    select '2022-03-16 08:15:00',430.0,54
    union all
    select '2022-03-16 08:28:00',526.0,27
    union all
    select '2022-03-16 08:55:00',944.0,73
    union all
    select '2022-03-16 12:41:00',410.0,17
    union all
    select '2022-03-16 12:46:00',608.0,76
    union all
    select '2022-03-16 13:15:00',534.0,13
    union all
    select '2022-03-16 13:23:00',240.0,78
    union all
    select '2022-03-16 16:02:00',188.0,78
    union all
    select '2022-03-16 16:58:00',956.0,8
    union all
    select '2022-03-16 17:15:00',518.0,45
    union all
    select '2022-03-16 20:54:00',892.0,70
    union all
    select '2022-03-16 21:54:00',634.0,46
    union all
    select '2022-03-17 00:00:00',374.0,57
    union all
    select '2022-03-17 00:21:00',290.0,52
    union all
    select '2022-03-17 00:57:00',908.0,69
    union all
    select '2022-03-17 02:39:00',784.0,29
    union all
    select '2022-03-17 05:33:00',776.0,37
    union all
    select '2022-03-17 05:51:00',802.0,42
    union all
    select '2022-03-17 06:17:00',108.0,10
    union all
    select '2022-03-17 08:01:00',234.0,69
    union all
    select '2022-03-17 10:11:00',460.0,43
    union all
    select '2022-03-17 10:15:00',434.0,79
    union all
    select '2022-03-17 10:22:00',956.0,17
    union all
    select '2022-03-17 12:09:00',446.0,96
    union all
    select '2022-03-17 13:50:00',802.0,80
    union all
    select '2022-03-17 15:05:00',948.0,73
    union all
    select '2022-03-17 15:49:00',960.0,50
    union all
    select '2022-03-17 17:25:00',560.0,51
    union all
    select '2022-03-17 17:48:00',660.0,83
    union all
    select '2022-03-17 18:34:00',926.0,38
    union all
    select '2022-03-17 19:00:00',836.0,15
    union all
    select '2022-03-17 19:46:00',938.0,19
    union all
    select '2022-03-17 20:21:00',302.0,90
    union all
    select '2022-03-17 20:26:00',264.0,78
    union all
    select '2022-03-17 21:03:00',694.0,92
    union all
    select '2022-03-17 22:46:00',328.0,62
    union all
    select '2022-03-18 01:15:00',480.0,48
    union all
    select '2022-03-18 01:40:00',708.0,73
    union all
    select '2022-03-18 03:14:00',792.0,99
    union all
    select '2022-03-18 04:08:00',506.0,90
    union all
    select '2022-03-18 08:25:00',466.0,30
    union all
    select '2022-03-18 09:29:00',572.0,83
    union all
    select '2022-03-18 09:45:00',362.0,38
    union all
    select '2022-03-18 10:22:00',514.0,4
    union all
    select '2022-03-18 12:48:00',520.0,23
    union all
    select '2022-03-18 13:28:00',240.0,82
    union all
    select '2022-03-18 13:43:00',558.0,68
    union all
    select '2022-03-18 13:51:00',208.0,14
    union all
    select '2022-03-18 14:28:00',540.0,96
    union all
    select '2022-03-18 16:28:00',132.0,19
    union all
    select '2022-03-18 16:30:00',262.0,14
    union all
    select '2022-03-18 16:45:00',864.0,64
    union all
    select '2022-03-18 17:32:00',548.0,92
    union all
    select '2022-03-18 18:06:00',996.0,8
    union all
    select '2022-03-18 18:16:00',690.0,85
    union all
    select '2022-03-18 18:23:00',566.0,30
    union all
    select '2022-03-18 19:02:00',756.0,56
    union all
    select '2022-03-18 19:05:00',462.0,60
    union all
    select '2022-03-18 21:39:00',486.0,29
    union all
    select '2022-03-18 22:54:00',476.0,76
    union all
    select '2022-03-18 23:59:00',912.0,62
    union all
    select '2022-03-19 02:17:00',162.0,90
    union all
    select '2022-03-19 03:12:00',164.0,65
    union all
    select '2022-03-19 03:35:00',302.0,32
    union all
    select '2022-03-19 06:17:00',222.0,86
    union all
    select '2022-03-19 07:33:00',420.0,57
    union all
    select '2022-03-19 09:51:00',390.0,96
    union all
    select '2022-03-19 10:53:00',658.0,61
    union all
    select '2022-03-19 10:54:00',738.0,91
    union all
    select '2022-03-19 10:57:00',470.0,9
    union all
    select '2022-03-19 12:11:00',414.0,3
    union all
    select '2022-03-19 12:14:00',886.0,45
    union all
    select '2022-03-19 13:44:00',924.0,94
    union all
    select '2022-03-19 13:47:00',518.0,19
    union all
    select '2022-03-19 14:07:00',218.0,90
    union all
    select '2022-03-19 14:29:00',192.0,57
    union all
    select '2022-03-19 17:49:00',520.0,13
    union all
    select '2022-03-19 18:14:00',326.0,12
    union all
    select '2022-03-19 19:43:00',750.0,17
    union all
    select '2022-03-19 21:16:00',398.0,76
    union all
    select '2022-03-19 21:30:00',534.0,71
    union all
    select '2022-03-19 22:12:00',990.0,91
    union all
    select '2022-03-19 22:52:00',440.0,63
    union all
    select '2022-03-20 01:42:00',160.0,72
    union all
    select '2022-03-20 02:53:00',798.0,99
    union all
    select '2022-03-20 03:21:00',850.0,31
    union all
    select '2022-03-20 04:47:00',224.0,68
    union all
    select '2022-03-20 05:00:00',612.0,90
    union all
    select '2022-03-20 06:13:00',164.0,53
    union all
    select '2022-03-20 06:21:00',328.0,38
    union all
    select '2022-03-20 06:38:00',424.0,1
    union all
    select '2022-03-20 06:57:00',666.0,75
    union all
    select '2022-03-20 07:05:00',354.0,69
    union all
    select '2022-03-20 09:17:00',370.0,80
    union all
    select '2022-03-20 09:35:00',426.0,62
    union all
    select '2022-03-20 10:34:00',568.0,40
    union all
    select '2022-03-20 11:18:00',810.0,82
    union all
    select '2022-03-20 11:23:00',578.0,84
    union all
    select '2022-03-20 15:13:00',630.0,19
    union all
    select '2022-03-20 15:43:00',860.0,48
    union all
    select '2022-03-20 16:12:00',954.0,92
    union all
    select '2022-03-20 16:35:00',552.0,90
    union all
    select '2022-03-20 17:47:00',668.0,91
    union all
    select '2022-03-20 18:00:00',474.0,63
    union all
    select '2022-03-20 18:35:00',856.0,51
    union all
    select '2022-03-20 18:37:00',690.0,5
    union all
    select '2022-03-21 00:27:00',254.0,28
    union all
    select '2022-03-21 03:00:00',308.0,13
    union all
    select '2022-03-21 03:12:00',264.0,14
    union all
    select '2022-03-21 04:30:00',292.0,89
    union all
    select '2022-03-21 04:48:00',822.0,93
    union all
    select '2022-03-21 05:40:00',648.0,74
    union all
    select '2022-03-21 05:56:00',448.0,11
    union all
    select '2022-03-21 05:59:00',548.0,41
    union all
    select '2022-03-21 06:37:00',766.0,15
    union all
    select '2022-03-21 07:30:00',722.0,98
    union all
    select '2022-03-21 08:11:00',136.0,98
    union all
    select '2022-03-21 08:32:00',158.0,31
    union all
    select '2022-03-21 09:26:00',854.0,61
    union all
    select '2022-03-21 10:15:00',906.0,35
    union all
    select '2022-03-21 11:20:00',398.0,27
    union all
    select '2022-03-21 11:24:00',126.0,80
    union all
    select '2022-03-21 13:55:00',948.0,56
    union all
    select '2022-03-21 14:22:00',300.0,69
    union all
    select '2022-03-21 14:32:00',868.0,96
    union all
    select '2022-03-21 14:37:00',970.0,34
    union all
    select '2022-03-21 15:16:00',964.0,82
    union all
    select '2022-03-21 16:33:00',210.0,91
    union all
    select '2022-03-21 16:46:00',108.0,43
    union all
    select '2022-03-21 17:05:00',558.0,73
    union all
    select '2022-03-21 17:48:00',142.0,56
    union all
    select '2022-03-21 18:14:00',528.0,56
    union all
    select '2022-03-21 19:21:00',102.0,71
    union all
    select '2022-03-21 19:40:00',300.0,63
    union all
    select '2022-03-21 20:06:00',914.0,24
    union all
    select '2022-03-21 20:21:00',688.0,92
    union all
    select '2022-03-21 22:34:00',228.0,18
    union all
    select '2022-03-21 23:52:00',548.0,93
    union all
    select '2022-03-22 00:09:00',802.0,93
    union all
    select '2022-03-22 02:43:00',966.0,5
    union all
    select '2022-03-22 03:25:00',492.0,82
    union all
    select '2022-03-22 03:34:00',140.0,2
    union all
    select '2022-03-22 03:54:00',616.0,37
    union all
    select '2022-03-22 04:21:00',218.0,79
    union all
    select '2022-03-22 04:49:00',404.0,25
    union all
    select '2022-03-22 05:30:00',126.0,11
    union all
    select '2022-03-22 05:47:00',102.0,67
    union all
    select '2022-03-22 07:18:00',238.0,67
    union all
    select '2022-03-22 08:54:00',456.0,71
    union all
    select '2022-03-22 10:36:00',106.0,95
    union all
    select '2022-03-22 11:46:00',138.0,62
    union all
    select '2022-03-22 12:11:00',372.0,82
    union all
    select '2022-03-22 17:25:00',772.0,12
    union all
    select '2022-03-22 18:47:00',140.0,80
    union all
    select '2022-03-22 21:00:00',188.0,60
    union all
    select '2022-03-22 22:26:00',444.0,40
    union all
    select '2022-03-22 23:12:00',542.0,71
    union all
    select '2022-03-22 23:33:00',640.0,9
    union all
    select '2022-03-22 23:51:00',408.0,33
    union all
    select '2022-03-23 03:52:00',928.0,2
    union all
    select '2022-03-23 04:43:00',792.0,35
    union all
    select '2022-03-23 06:03:00',610.0,48
    union all
    select '2022-03-23 06:35:00',856.0,92
    union all
    select '2022-03-23 06:58:00',454.0,10
    union all
    select '2022-03-23 07:26:00',390.0,26
    union all
    select '2022-03-23 08:49:00',342.0,67
    union all
    select '2022-03-23 09:05:00',144.0,64
    union all
    select '2022-03-23 09:51:00',530.0,87
    union all
    select '2022-03-23 10:35:00',440.0,62
    union all
    select '2022-03-23 10:46:00',160.0,50
    union all
    select '2022-03-23 11:28:00',698.0,62
    union all
    select '2022-03-23 11:49:00',766.0,24
    union all
    select '2022-03-23 12:50:00',766.0,28
    union all
    select '2022-03-23 13:04:00',702.0,38
    union all
    select '2022-03-23 15:13:00',832.0,81
    union all
    select '2022-03-23 17:13:00',550.0,83
    union all
    select '2022-03-23 17:43:00',898.0,62
    union all
    select '2022-03-23 17:57:00',386.0,56
    union all
    select '2022-03-23 18:18:00',122.0,11
    union all
    select '2022-03-23 18:45:00',760.0,14
    union all
    select '2022-03-23 18:56:00',528.0,40
    union all
    select '2022-03-23 19:30:00',366.0,79
    union all
    select '2022-03-23 19:56:00',182.0,61
    union all
    select '2022-03-23 21:37:00',274.0,93
    union all
    select '2022-03-23 22:47:00',418.0,66
    union all
    select '2022-03-23 23:00:00',678.0,4
    union all
    select '2022-03-23 23:21:00',142.0,34
    union all
    select '2022-03-23 23:46:00',104.0,8
    union all
    select '2022-03-23 23:52:00',340.0,91
    union all
    select '2022-03-24 00:55:00',724.0,67
    union all
    select '2022-03-24 01:12:00',468.0,89
    union all
    select '2022-03-24 01:18:00',116.0,31
    union all
    select '2022-03-24 02:39:00',144.0,52
    union all
    select '2022-03-24 02:39:00',246.0,56
    union all
    select '2022-03-24 03:13:00',852.0,18
    union all
    select '2022-03-24 05:24:00',136.0,25
    union all
    select '2022-03-24 05:25:00',432.0,7
    union all
    select '2022-03-24 06:16:00',360.0,68
    union all
    select '2022-03-24 06:46:00',258.0,53
    union all
    select '2022-03-24 08:20:00',988.0,16
    union all
    select '2022-03-24 08:40:00',536.0,76
    union all
    select '2022-03-24 08:53:00',780.0,72
    union all
    select '2022-03-24 08:58:00',720.0,32
    union all
    select '2022-03-24 08:59:00',820.0,76
    union all
    select '2022-03-24 10:38:00',660.0,7
    union all
    select '2022-03-24 13:12:00',516.0,95
    union all
    select '2022-03-24 13:49:00',290.0,9
    union all
    select '2022-03-24 15:14:00',216.0,98
    union all
    select '2022-03-24 15:15:00',456.0,45
    union all
    select '2022-03-24 16:07:00',460.0,11
    union all
    select '2022-03-24 16:42:00',730.0,5
    union all
    select '2022-03-24 18:23:00',288.0,90
    union all
    select '2022-03-24 20:21:00',870.0,6
    union all
    select '2022-03-24 21:12:00',526.0,82
    union all
    select '2022-03-24 22:26:00',146.0,33
    union all
    select '2022-03-25 01:12:00',738.0,15
    union all
    select '2022-03-25 01:13:00',814.0,57
    union all
    select '2022-03-25 02:23:00',160.0,87
    union all
    select '2022-03-25 03:48:00',294.0,96
    union all
    select '2022-03-25 05:08:00',356.0,1
    union all
    select '2022-03-25 06:06:00',156.0,96
    union all
    select '2022-03-25 06:48:00',876.0,66
    union all
    select '2022-03-25 09:32:00',328.0,66
    union all
    select '2022-03-25 10:10:00',302.0,3
    union all
    select '2022-03-25 10:14:00',940.0,97
    union all
    select '2022-03-25 10:26:00',244.0,78
    union all
    select '2022-03-25 11:26:00',832.0,53
    union all
    select '2022-03-25 11:50:00',540.0,30
    union all
    select '2022-03-25 12:18:00',650.0,91
    union all
    select '2022-03-25 15:22:00',302.0,47
    union all
    select '2022-03-25 15:51:00',638.0,89
    union all
    select '2022-03-25 18:42:00',904.0,31
    union all
    select '2022-03-25 18:50:00',194.0,10
    union all
    select '2022-03-25 20:16:00',808.0,45
    union all
    select '2022-03-25 20:29:00',676.0,28
    union all
    select '2022-03-25 21:13:00',868.0,16
    union all
    select '2022-03-25 21:30:00',924.0,16
    union all
    select '2022-03-25 21:38:00',390.0,66
    union all
    select '2022-03-25 23:00:00',284.0,25
    union all
    select '2022-03-25 23:16:00',416.0,54
    union all
    select '2022-03-26 00:25:00',956.0,67
    union all
    select '2022-03-26 01:18:00',404.0,20
    union all
    select '2022-03-26 01:27:00',436.0,18
    union all
    select '2022-03-26 01:52:00',114.0,20
    union all
    select '2022-03-26 01:53:00',780.0,48
    union all
    select '2022-03-26 06:46:00',832.0,92
    union all
    select '2022-03-26 07:08:00',476.0,95
    union all
    select '2022-03-26 08:38:00',608.0,91
    union all
    select '2022-03-26 09:07:00',318.0,71
    union all
    select '2022-03-26 09:34:00',520.0,83
    union all
    select '2022-03-26 12:06:00',488.0,16
    union all
    select '2022-03-26 12:34:00',178.0,24
    union all
    select '2022-03-26 12:49:00',392.0,69
    union all
    select '2022-03-26 13:58:00',930.0,49
    union all
    select '2022-03-26 15:48:00',190.0,2
    union all
    select '2022-03-26 17:36:00',240.0,97
    union all
    select '2022-03-26 18:44:00',522.0,15
    union all
    select '2022-03-26 19:30:00',412.0,17
    union all
    select '2022-03-26 20:22:00',250.0,41
    union all
    select '2022-03-26 20:22:00',712.0,69
    union all
    select '2022-03-26 23:18:00',320.0,31
    union all
    select '2022-03-27 00:51:00',934.0,7
    union all
    select '2022-03-27 01:31:00',164.0,15
    union all
    select '2022-03-27 02:07:00',980.0,52
    union all
    select '2022-03-27 02:38:00',662.0,67
    union all
    select '2022-03-27 03:39:00',378.0,26
    union all
    select '2022-03-27 03:56:00',730.0,39
    union all
    select '2022-03-27 04:04:00',528.0,7
    union all
    select '2022-03-27 04:16:00',182.0,87
    union all
    select '2022-03-27 05:54:00',618.0,61
    union all
    select '2022-03-27 06:05:00',970.0,41
    union all
    select '2022-03-27 06:42:00',390.0,89
    union all
    select '2022-03-27 07:13:00',784.0,89
    union all
    select '2022-03-27 08:15:00',788.0,6
    union all
    select '2022-03-27 09:05:00',120.0,24
    union all
    select '2022-03-27 09:36:00',388.0,22
    union all
    select '2022-03-27 09:56:00',722.0,57
    union all
    select '2022-03-27 10:23:00',140.0,97
    union all
    select '2022-03-27 11:00:00',248.0,4
    union all
    select '2022-03-27 13:59:00',990.0,14
    union all
    select '2022-03-27 17:07:00',600.0,47
    union all
    select '2022-03-27 18:26:00',586.0,24
    union all
    select '2022-03-27 18:53:00',386.0,57
    union all
    select '2022-03-27 20:51:00',128.0,54
    union all
    select '2022-03-27 21:37:00',542.0,10
    union all
    select '2022-03-27 22:15:00',928.0,2
    union all
    select '2022-03-27 22:47:00',918.0,39
    union all
    select '2022-03-28 00:26:00',112.0,9
    union all
    select '2022-03-28 00:30:00',440.0,36
    union all
    select '2022-03-28 00:59:00',214.0,79
    union all
    select '2022-03-28 02:06:00',536.0,60
    union all
    select '2022-03-28 02:29:00',112.0,14
    union all
    select '2022-03-28 03:34:00',624.0,41
    union all
    select '2022-03-28 05:41:00',396.0,59
    union all
    select '2022-03-28 06:07:00',998.0,61
    union all
    select '2022-03-28 06:21:00',910.0,88
    union all
    select '2022-03-28 06:25:00',244.0,77
    union all
    select '2022-03-28 07:28:00',228.0,64
    union all
    select '2022-03-28 07:29:00',598.0,75
    union all
    select '2022-03-28 07:58:00',190.0,93
    union all
    select '2022-03-28 08:39:00',142.0,71
    union all
    select '2022-03-28 09:08:00',236.0,76
    union all
    select '2022-03-28 09:22:00',942.0,60
    union all
    select '2022-03-28 09:38:00',268.0,64
    union all
    select '2022-03-28 09:57:00',310.0,7
    union all
    select '2022-03-28 11:20:00',520.0,30
    union all
    select '2022-03-28 11:42:00',994.0,6
    union all
    select '2022-03-28 13:02:00',720.0,28
    union all
    select '2022-03-28 13:08:00',902.0,13
    union all
    select '2022-03-28 14:24:00',160.0,44
    union all
    select '2022-03-28 14:41:00',454.0,42
    union all
    select '2022-03-28 15:11:00',794.0,28
    union all
    select '2022-03-28 15:41:00',308.0,63
    union all
    select '2022-03-28 20:49:00',174.0,39
    union all
    select '2022-03-28 21:33:00',194.0,7
    union all
    select '2022-03-29 00:52:00',200.0,61
    union all
    select '2022-03-29 01:25:00',806.0,19
    union all
    select '2022-03-29 03:57:00',228.0,21
    union all
    select '2022-03-29 04:31:00',188.0,5
    union all
    select '2022-03-29 06:22:00',166.0,17
    union all
    select '2022-03-29 07:16:00',972.0,57
    union all
    select '2022-03-29 08:04:00',806.0,96
    union all
    select '2022-03-29 09:46:00',384.0,24
    union all
    select '2022-03-29 09:59:00',414.0,12
    union all
    select '2022-03-29 11:06:00',540.0,17
    union all
    select '2022-03-29 12:12:00',356.0,64
    union all
    select '2022-03-29 12:58:00',510.0,42
    union all
    select '2022-03-29 13:07:00',278.0,2
    union all
    select '2022-03-29 14:19:00',304.0,59
    union all
    select '2022-03-29 14:58:00',414.0,21
    union all
    select '2022-03-29 15:10:00',420.0,73
    union all
    select '2022-03-29 16:18:00',980.0,41
    union all
    select '2022-03-29 16:48:00',232.0,76
    union all
    select '2022-03-29 17:01:00',768.0,71
    union all
    select '2022-03-29 17:47:00',432.0,15
    union all
    select '2022-03-29 19:28:00',704.0,92
    union all
    select '2022-03-29 19:48:00',814.0,30
    union all
    select '2022-03-29 20:06:00',252.0,79
    union all
    select '2022-03-29 20:33:00',976.0,70
    union all
    select '2022-03-29 21:12:00',864.0,12
    union all
    select '2022-03-29 22:18:00',714.0,71
    union all
    select '2022-03-29 22:39:00',206.0,42
    union all
    select '2022-03-29 22:54:00',814.0,5
    union all
    select '2022-03-30 01:15:00',684.0,2
    union all
    select '2022-03-30 04:54:00',788.0,56
    union all
    select '2022-03-30 06:29:00',216.0,36
    union all
    select '2022-03-30 06:50:00',412.0,88
    union all
    select '2022-03-30 08:19:00',372.0,13
    union all
    select '2022-03-30 09:02:00',574.0,58
    union all
    select '2022-03-30 11:52:00',680.0,17
    union all
    select '2022-03-30 12:11:00',470.0,58
    union all
    select '2022-03-30 13:08:00',908.0,42
    union all
    select '2022-03-30 14:05:00',568.0,15
    union all
    select '2022-03-30 15:51:00',746.0,39
    union all
    select '2022-03-30 16:06:00',384.0,34
    union all
    select '2022-03-30 18:33:00',974.0,66
    union all
    select '2022-03-30 19:13:00',386.0,87
    union all
    select '2022-03-30 22:14:00',584.0,72
    union all
    select '2022-03-30 22:31:00',474.0,82
    union all
    select '2022-03-30 23:52:00',602.0,4
    union all
    select '2022-03-30 23:56:00',340.0,52
    union all
    select '2022-03-31 01:13:00',670.0,59
    union all
    select '2022-03-31 01:22:00',914.0,89
    union all
    select '2022-03-31 02:27:00',548.0,74
    union all
    select '2022-03-31 02:46:00',536.0,1
    union all
    select '2022-03-31 04:01:00',698.0,28
    union all
    select '2022-03-31 04:37:00',494.0,15
    union all
    select '2022-03-31 06:05:00',660.0,48
    union all
    select '2022-03-31 06:18:00',390.0,56
    union all
    select '2022-03-31 08:52:00',362.0,91
    union all
    select '2022-03-31 08:59:00',836.0,16
    union all
    select '2022-03-31 10:05:00',786.0,51
    union all
    select '2022-03-31 12:00:00',598.0,36
    union all
    select '2022-03-31 12:28:00',490.0,55
    union all
    select '2022-03-31 13:08:00',868.0,90
    union all
    select '2022-03-31 13:23:00',590.0,26
    union all
    select '2022-03-31 14:54:00',368.0,56
    union all
    select '2022-03-31 15:55:00',864.0,98
    union all
    select '2022-03-31 16:45:00',964.0,93
    union all
    select '2022-03-31 16:59:00',422.0,28
    union all
    select '2022-03-31 17:05:00',986.0,43
    union all
    select '2022-03-31 18:03:00',654.0,39
    union all
    select '2022-03-31 18:28:00',222.0,88
    union all
    select '2022-03-31 18:42:00',998.0,46
    union all
    select '2022-03-31 20:39:00',486.0,39
    union all
    select '2022-03-31 20:51:00',904.0,69
    union all
    select '2022-03-31 22:10:00',364.0,98
    union all
    select '2022-03-31 22:39:00',360.0,61
    union all
    select '2022-03-31 23:31:00',710.0,31
    union all
    select '2022-04-01 00:28:00',318.0,82
    union all
    select '2022-04-01 04:08:00',314.0,86
    union all
    select '2022-04-01 05:11:00',100.0,31
    union all
    select '2022-04-01 05:23:00',710.0,79
    union all
    select '2022-04-01 05:25:00',382.0,27
    union all
    select '2022-04-01 07:21:00',134.0,75
    union all
    select '2022-04-01 09:20:00',732.0,76
    union all
    select '2022-04-01 11:24:00',384.0,67
    union all
    select '2022-04-01 13:31:00',746.0,49
    union all
    select '2022-04-01 13:39:00',278.0,16
    union all
    select '2022-04-01 13:54:00',220.0,3
    union all
    select '2022-04-01 14:14:00',290.0,88
    union all
    select '2022-04-01 15:07:00',672.0,18
    union all
    select '2022-04-01 18:40:00',386.0,46
    union all
    select '2022-04-01 19:25:00',404.0,54
    union all
    select '2022-04-01 20:11:00',750.0,73
    union all
    select '2022-04-01 21:43:00',852.0,25
    union all
    select '2022-04-01 21:53:00',962.0,38
    union all
    select '2022-04-01 22:19:00',630.0,65
    union all
    select '2022-04-01 22:33:00',636.0,15
    union all
    select '2022-04-02 01:02:00',366.0,55
    union all
    select '2022-04-02 02:08:00',932.0,40
    union all
    select '2022-04-02 06:27:00',864.0,63
    union all
    select '2022-04-02 07:36:00',374.0,27
    union all
    select '2022-04-02 08:14:00',380.0,60
    union all
    select '2022-04-02 08:41:00',476.0,62
    union all
    select '2022-04-02 09:43:00',108.0,49
    union all
    select '2022-04-02 10:46:00',364.0,65
    union all
    select '2022-04-02 10:47:00',880.0,9
    union all
    select '2022-04-02 11:17:00',224.0,14
    union all
    select '2022-04-02 12:27:00',600.0,2
    union all
    select '2022-04-02 12:41:00',598.0,39
    union all
    select '2022-04-02 15:14:00',290.0,38
    union all
    select '2022-04-02 16:10:00',162.0,90
    union all
    select '2022-04-02 16:37:00',734.0,71
    union all
    select '2022-04-02 16:46:00',934.0,69
    union all
    select '2022-04-02 19:22:00',360.0,37
    union all
    select '2022-04-02 22:26:00',692.0,13
    union all
    select '2022-04-02 23:00:00',158.0,74
    union all
    select '2022-04-03 00:17:00',462.0,64
    union all
    select '2022-04-03 00:21:00',614.0,27
    union all
    select '2022-04-03 06:04:00',696.0,26
    union all
    select '2022-04-03 06:18:00',248.0,12
    union all
    select '2022-04-03 06:42:00',826.0,56
    union all
    select '2022-04-03 06:54:00',116.0,83
    union all
    select '2022-04-03 08:21:00',500.0,4
    union all
    select '2022-04-03 10:28:00',536.0,26
    union all
    select '2022-04-03 10:32:00',514.0,9
    union all
    select '2022-04-03 12:15:00',784.0,25
    union all
    select '2022-04-03 12:49:00',934.0,61
    union all
    select '2022-04-03 13:14:00',334.0,20
    union all
    select '2022-04-03 14:52:00',408.0,43
    union all
    select '2022-04-03 15:23:00',854.0,34
    union all
    select '2022-04-03 15:51:00',748.0,73
    union all
    select '2022-04-03 17:10:00',858.0,81
    union all
    select '2022-04-03 21:00:00',324.0,98
    union all
    select '2022-04-04 00:15:00',136.0,97
    union all
    select '2022-04-04 01:14:00',140.0,11
    union all
    select '2022-04-04 01:28:00',290.0,70
    union all
    select '2022-04-04 03:09:00',798.0,48
    union all
    select '2022-04-04 03:22:00',662.0,48
    union all
    select '2022-04-04 05:44:00',256.0,18
    union all
    select '2022-04-04 05:55:00',976.0,99
    union all
    select '2022-04-04 06:08:00',508.0,70
    union all
    select '2022-04-04 06:39:00',470.0,95
    union all
    select '2022-04-04 07:19:00',216.0,97
    union all
    select '2022-04-04 09:43:00',220.0,94
    union all
    select '2022-04-04 11:03:00',526.0,78
    union all
    select '2022-04-04 14:03:00',930.0,65
    union all
    select '2022-04-04 16:55:00',132.0,60
    union all
    select '2022-04-04 16:58:00',768.0,10
    union all
    select '2022-04-04 17:54:00',932.0,82
    union all
    select '2022-04-04 18:23:00',392.0,90
    union all
    select '2022-04-04 20:39:00',116.0,29
    union all
    select '2022-04-04 22:43:00',824.0,73
    union all
    select '2022-04-04 23:22:00',674.0,41
    union all
    select '2022-04-05 00:36:00',294.0,5
    union all
    select '2022-04-05 01:34:00',210.0,24
    union all
    select '2022-04-05 02:37:00',126.0,88
    union all
    select '2022-04-05 04:22:00',814.0,90
    union all
    select '2022-04-05 04:59:00',312.0,24
    union all
    select '2022-04-05 05:21:00',616.0,97
    union all
    select '2022-04-05 10:18:00',342.0,21
    union all
    select '2022-04-05 11:28:00',200.0,28
    union all
    select '2022-04-05 11:45:00',554.0,22
    union all
    select '2022-04-05 11:51:00',398.0,17
    union all
    select '2022-04-05 12:10:00',522.0,30
    union all
    select '2022-04-05 12:12:00',172.0,29
    union all
    select '2022-04-05 12:31:00',482.0,29
    union all
    select '2022-04-05 12:47:00',818.0,16
    union all
    select '2022-04-05 13:20:00',342.0,15
    union all
    select '2022-04-05 13:23:00',854.0,96
    union all
    select '2022-04-05 14:53:00',620.0,71
    union all
    select '2022-04-05 17:06:00',730.0,83
    union all
    select '2022-04-05 17:44:00',298.0,12
    union all
    select '2022-04-05 18:41:00',214.0,57
    union all
    select '2022-04-05 19:05:00',398.0,61
    union all
    select '2022-04-05 19:43:00',598.0,20
    union all
    select '2022-04-05 20:30:00',620.0,70
    union all
    select '2022-04-05 20:42:00',408.0,64
    union all
    select '2022-04-05 20:46:00',580.0,89
    union all
    select '2022-04-05 21:33:00',652.0,67
    union all
    select '2022-04-06 02:49:00',710.0,9
    union all
    select '2022-04-06 03:52:00',384.0,25
    union all
    select '2022-04-06 03:57:00',916.0,62
    union all
    select '2022-04-06 04:06:00',344.0,82
    union all
    select '2022-04-06 05:15:00',776.0,48
    union all
    select '2022-04-06 06:17:00',928.0,71
    union all
    select '2022-04-06 06:51:00',764.0,48
    union all
    select '2022-04-06 07:50:00',404.0,65
    union all
    select '2022-04-06 09:27:00',944.0,70
    union all
    select '2022-04-06 09:45:00',142.0,55
    union all
    select '2022-04-06 12:37:00',858.0,24
    union all
    select '2022-04-06 12:48:00',100.0,57
    union all
    select '2022-04-06 13:45:00',760.0,97
    union all
    select '2022-04-06 14:18:00',886.0,81
    union all
    select '2022-04-06 15:16:00',138.0,29
    union all
    select '2022-04-06 15:19:00',472.0,67
    union all
    select '2022-04-06 15:35:00',938.0,70
    union all
    select '2022-04-06 16:56:00',128.0,56
    union all
    select '2022-04-06 17:04:00',140.0,25
    union all
    select '2022-04-06 17:11:00',142.0,19
    union all
    select '2022-04-06 18:43:00',274.0,65
    union all
    select '2022-04-06 19:26:00',818.0,75
    union all
    select '2022-04-06 20:21:00',866.0,95
    union all
    select '2022-04-06 22:46:00',128.0,31
    union all
    select '2022-04-06 23:53:00',248.0,65
    union all
    select '2022-04-07 00:04:00',362.0,45
    union all
    select '2022-04-07 00:14:00',410.0,46
    union all
    select '2022-04-07 00:16:00',296.0,39
    union all
    select '2022-04-07 04:18:00',394.0,11
    union all
    select '2022-04-07 05:36:00',802.0,33
    union all
    select '2022-04-07 06:02:00',624.0,11
    union all
    select '2022-04-07 06:22:00',576.0,19
    union all
    select '2022-04-07 06:31:00',896.0,66
    union all
    select '2022-04-07 07:22:00',718.0,28
    union all
    select '2022-04-07 09:53:00',742.0,19
    union all
    select '2022-04-07 11:38:00',502.0,14
    union all
    select '2022-04-07 11:56:00',644.0,6
    union all
    select '2022-04-07 15:13:00',656.0,76
    union all
    select '2022-04-07 16:20:00',668.0,81
    union all
    select '2022-04-07 17:43:00',766.0,40
    union all
    select '2022-04-07 18:01:00',958.0,14
    union all
    select '2022-04-07 18:47:00',540.0,96
    union all
    select '2022-04-07 18:49:00',896.0,32
    union all
    select '2022-04-07 19:06:00',690.0,1
    union all
    select '2022-04-07 22:53:00',682.0,91
    union all
    select '2022-04-07 22:54:00',786.0,44
    union all
    select '2022-04-08 00:03:00',574.0,3
    union all
    select '2022-04-08 01:04:00',644.0,35
    union all
    select '2022-04-08 01:35:00',862.0,22
    union all
    select '2022-04-08 02:03:00',726.0,61
    union all
    select '2022-04-08 02:08:00',978.0,17
    union all
    select '2022-04-08 03:25:00',198.0,8
    union all
    select '2022-04-08 03:26:00',820.0,9
    union all
    select '2022-04-08 03:31:00',814.0,30
    union all
    select '2022-04-08 04:42:00',810.0,54
    union all
    select '2022-04-08 05:31:00',754.0,73
    union all
    select '2022-04-08 09:48:00',680.0,56
    union all
    select '2022-04-08 11:28:00',480.0,33
    union all
    select '2022-04-08 12:00:00',970.0,67
    union all
    select '2022-04-08 13:12:00',244.0,41
    union all
    select '2022-04-08 13:30:00',248.0,46
    union all
    select '2022-04-08 15:42:00',266.0,56
    union all
    select '2022-04-08 15:49:00',588.0,20
    union all
    select '2022-04-08 16:13:00',184.0,90
    union all
    select '2022-04-08 16:38:00',224.0,96
    union all
    select '2022-04-08 17:22:00',240.0,85
    union all
    select '2022-04-08 17:44:00',336.0,31
    union all
    select '2022-04-08 17:57:00',810.0,97
    union all
    select '2022-04-08 19:42:00',974.0,98
    union all
    select '2022-04-08 19:57:00',458.0,52
    union all
    select '2022-04-08 20:30:00',182.0,16
    union all
    select '2022-04-08 20:54:00',316.0,52
    union all
    select '2022-04-09 01:07:00',796.0,15
    union all
    select '2022-04-09 01:11:00',764.0,46
    union all
    select '2022-04-09 01:31:00',646.0,26
    union all
    select '2022-04-09 03:03:00',368.0,11
    union all
    select '2022-04-09 03:44:00',580.0,45
    union all
    select '2022-04-09 04:30:00',470.0,75
    union all
    select '2022-04-09 04:31:00',762.0,39
    union all
    select '2022-04-09 04:47:00',254.0,43
    union all
    select '2022-04-09 05:54:00',670.0,81
    union all
    select '2022-04-09 07:08:00',804.0,50
    union all
    select '2022-04-09 07:36:00',424.0,52
    union all
    select '2022-04-09 08:36:00',814.0,76
    union all
    select '2022-04-09 12:32:00',984.0,16
    union all
    select '2022-04-09 14:08:00',838.0,15
    union all
    select '2022-04-09 20:39:00',908.0,2
    union all
    select '2022-04-09 23:11:00',614.0,59
    union all
    select '2022-04-09 23:23:00',738.0,30
    union all
    select '2022-04-10 01:22:00',880.0,68
    union all
    select '2022-04-10 02:19:00',268.0,80
    union all
    select '2022-04-10 02:25:00',916.0,48
    union all
    select '2022-04-10 03:02:00',694.0,2
    union all
    select '2022-04-10 04:18:00',486.0,35
    union all
    select '2022-04-10 05:49:00',804.0,34
    union all
    select '2022-04-10 07:23:00',612.0,81
    union all
    select '2022-04-10 07:35:00',178.0,37
    union all
    select '2022-04-10 08:18:00',546.0,90
    union all
    select '2022-04-10 08:18:00',624.0,89
    union all
    select '2022-04-10 09:56:00',746.0,41
    union all
    select '2022-04-10 09:59:00',686.0,27
    union all
    select '2022-04-10 11:18:00',222.0,96
    union all
    select '2022-04-10 11:35:00',760.0,98
    union all
    select '2022-04-10 11:58:00',814.0,11
    union all
    select '2022-04-10 12:08:00',222.0,45
    union all
    select '2022-04-10 12:53:00',514.0,33
    union all
    select '2022-04-10 13:20:00',800.0,73
    union all
    select '2022-04-10 14:56:00',816.0,39
    union all
    select '2022-04-10 15:00:00',532.0,79
    union all
    select '2022-04-10 17:18:00',172.0,92
    union all
    select '2022-04-10 17:28:00',748.0,46
    union all
    select '2022-04-10 18:38:00',840.0,49
    union all
    select '2022-04-10 19:36:00',176.0,82
    union all
    select '2022-04-10 21:09:00',402.0,33
    union all
    select '2022-04-10 21:42:00',900.0,18
    union all
    select '2022-04-11 00:05:00',686.0,78
    union all
    select '2022-04-11 01:58:00',230.0,93
    union all
    select '2022-04-11 02:44:00',978.0,93
    union all
    select '2022-04-11 04:45:00',928.0,1
    union all
    select '2022-04-11 04:52:00',174.0,19
    union all
    select '2022-04-11 05:12:00',250.0,18
    union all
    select '2022-04-11 05:20:00',314.0,49
    union all
    select '2022-04-11 05:38:00',656.0,16
    union all
    select '2022-04-11 05:42:00',768.0,86
    union all
    select '2022-04-11 09:07:00',868.0,55
    union all
    select '2022-04-11 09:12:00',412.0,57
    union all
    select '2022-04-11 09:57:00',194.0,40
    union all
    select '2022-04-11 10:04:00',504.0,52
    union all
    select '2022-04-11 10:51:00',224.0,24
    union all
    select '2022-04-11 10:58:00',502.0,59
    union all
    select '2022-04-11 11:32:00',810.0,40
    union all
    select '2022-04-11 12:25:00',942.0,58
    union all
    select '2022-04-11 15:44:00',480.0,69
    union all
    select '2022-04-11 16:36:00',912.0,36
    union all
    select '2022-04-11 17:01:00',984.0,12
    union all
    select '2022-04-11 17:51:00',790.0,10
    union all
    select '2022-04-11 18:30:00',288.0,18
    union all
    select '2022-04-11 18:34:00',462.0,20
    union all
    select '2022-04-11 20:19:00',270.0,37
    union all
    select '2022-04-11 21:01:00',800.0,96
    union all
    select '2022-04-11 22:06:00',796.0,61
    union all
    select '2022-04-11 22:12:00',892.0,51
    union all
    select '2022-04-11 22:39:00',224.0,55
    union all
    select '2022-04-11 22:55:00',598.0,66
    union all
    select '2022-04-11 23:01:00',300.0,85
    union all
    select '2022-04-11 23:53:00',442.0,46
    union all
    select '2022-04-12 00:23:00',194.0,42
    union all
    select '2022-04-12 00:24:00',872.0,42
    union all
    select '2022-04-12 01:19:00',178.0,75
    union all
    select '2022-04-12 02:39:00',462.0,91
    union all
    select '2022-04-12 03:27:00',642.0,26
    union all
    select '2022-04-12 07:23:00',346.0,57
    union all
    select '2022-04-12 09:18:00',702.0,18
    union all
    select '2022-04-12 11:00:00',678.0,2
    union all
    select '2022-04-12 11:57:00',964.0,24
    union all
    select '2022-04-12 13:44:00',182.0,1
    union all
    select '2022-04-12 13:46:00',402.0,3
    union all
    select '2022-04-12 14:49:00',734.0,23
    union all
    select '2022-04-12 16:16:00',776.0,56
    union all
    select '2022-04-12 16:52:00',236.0,5
    union all
    select '2022-04-12 17:37:00',742.0,16
    union all
    select '2022-04-12 17:39:00',106.0,96
    union all
    select '2022-04-12 18:01:00',714.0,49
    union all
    select '2022-04-12 18:41:00',982.0,26
    union all
    select '2022-04-12 18:55:00',996.0,78
    union all
    select '2022-04-12 19:02:00',298.0,34
    union all
    select '2022-04-12 20:58:00',668.0,46
    union all
    select '2022-04-12 22:22:00',472.0,69
    union all
    select '2022-04-12 23:47:00',480.0,75
    union all
    select '2022-04-13 00:07:00',892.0,62
    union all
    select '2022-04-13 00:25:00',962.0,19
    union all
    select '2022-04-13 01:30:00',700.0,33
    union all
    select '2022-04-13 03:16:00',570.0,16
    union all
    select '2022-04-13 05:39:00',696.0,89
    union all
    select '2022-04-13 05:50:00',942.0,51
    union all
    select '2022-04-13 08:08:00',196.0,5
    union all
    select '2022-04-13 09:44:00',690.0,61
    union all
    select '2022-04-13 10:18:00',192.0,58
    union all
    select '2022-04-13 12:13:00',524.0,5
    union all
    select '2022-04-13 12:14:00',202.0,1
    union all
    select '2022-04-13 12:34:00',348.0,76
    union all
    select '2022-04-13 12:57:00',342.0,30
    union all
    select '2022-04-13 13:54:00',406.0,92
    union all
    select '2022-04-13 14:01:00',876.0,37
    union all
    select '2022-04-13 14:38:00',990.0,27
    union all
    select '2022-04-13 16:06:00',570.0,2
    union all
    select '2022-04-13 16:32:00',626.0,39
    union all
    select '2022-04-13 17:45:00',552.0,51
    union all
    select '2022-04-13 18:06:00',712.0,30
    union all
    select '2022-04-13 18:07:00',434.0,21
    union all
    select '2022-04-13 18:31:00',252.0,98
    union all
    select '2022-04-13 19:28:00',462.0,92
    union all
    select '2022-04-13 20:36:00',606.0,56
    union all
    select '2022-04-13 20:59:00',954.0,61
    union all
    select '2022-04-13 22:09:00',624.0,29
    union all
    select '2022-04-13 22:51:00',774.0,66
    union all
    select '2022-04-13 22:55:00',198.0,79
    union all
    select '2022-04-13 22:59:00',176.0,95
    union all
    select '2022-04-14 01:15:00',418.0,85
    union all
    select '2022-04-14 04:39:00',918.0,26
    union all
    select '2022-04-14 05:30:00',800.0,81
    union all
    select '2022-04-14 06:15:00',718.0,16
    union all
    select '2022-04-14 06:39:00',680.0,26
    union all
    select '2022-04-14 08:45:00',712.0,84
    union all
    select '2022-04-14 08:49:00',608.0,62
    union all
    select '2022-04-14 09:22:00',734.0,71
    union all
    select '2022-04-14 09:29:00',500.0,26
    union all
    select '2022-04-14 11:11:00',170.0,48
    union all
    select '2022-04-14 11:25:00',532.0,37
    union all
    select '2022-04-14 11:47:00',164.0,44
    union all
    select '2022-04-14 12:37:00',880.0,40
    union all
    select '2022-04-14 12:45:00',392.0,22
    union all
    select '2022-04-14 17:00:00',208.0,59
    union all
    select '2022-04-14 17:24:00',524.0,32
    union all
    select '2022-04-14 21:11:00',204.0,30
    union all
    select '2022-04-14 21:46:00',258.0,42
    union all
    select '2022-04-14 23:37:00',370.0,28
    union all
    select '2022-04-15 00:42:00',146.0,66
    union all
    select '2022-04-15 02:13:00',462.0,85
    union all
    select '2022-04-15 05:44:00',100.0,98
    union all
    select '2022-04-15 05:53:00',644.0,71
    union all
    select '2022-04-15 06:16:00',948.0,82
    union all
    select '2022-04-15 06:17:00',948.0,18
    union all
    select '2022-04-15 06:27:00',690.0,74
    union all
    select '2022-04-15 06:29:00',794.0,39
    union all
    select '2022-04-15 07:16:00',462.0,28
    union all
    select '2022-04-15 07:51:00',276.0,58
    union all
    select '2022-04-15 08:08:00',818.0,38
    union all
    select '2022-04-15 08:08:00',650.0,27
    union all
    select '2022-04-15 08:41:00',582.0,78
    union all
    select '2022-04-15 09:00:00',864.0,9
    union all
    select '2022-04-15 09:32:00',778.0,82
    union all
    select '2022-04-15 11:21:00',440.0,85
    union all
    select '2022-04-15 12:23:00',360.0,90
    union all
    select '2022-04-15 12:24:00',296.0,26
    union all
    select '2022-04-15 13:10:00',956.0,83
    union all
    select '2022-04-15 13:20:00',420.0,64
    union all
    select '2022-04-15 13:42:00',128.0,87
    union all
    select '2022-04-15 16:08:00',302.0,68
    union all
    select '2022-04-15 17:33:00',602.0,71
    union all
    select '2022-04-15 17:46:00',318.0,93
    union all
    select '2022-04-15 17:54:00',592.0,27
    union all
    select '2022-04-15 18:56:00',774.0,92
    union all
    select '2022-04-15 19:17:00',368.0,1
    union all
    select '2022-04-15 19:45:00',790.0,10
    union all
    select '2022-04-15 20:12:00',976.0,65
    union all
    select '2022-04-15 20:38:00',664.0,12
    union all
    select '2022-04-15 21:42:00',130.0,63
    union all
    select '2022-04-15 22:19:00',314.0,56
    union all
    select '2022-04-15 23:01:00',578.0,80
    union all
    select '2022-04-16 00:33:00',412.0,84
    union all
    select '2022-04-16 03:00:00',198.0,90
    union all
    select '2022-04-16 03:39:00',318.0,49
    union all
    select '2022-04-16 05:02:00',344.0,20
    union all
    select '2022-04-16 09:32:00',678.0,39
    union all
    select '2022-04-16 10:08:00',526.0,67
    union all
    select '2022-04-16 13:58:00',338.0,77
    union all
    select '2022-04-16 14:53:00',476.0,83
    union all
    select '2022-04-16 18:59:00',320.0,83
    union all
    select '2022-04-16 19:34:00',568.0,95
    union all
    select '2022-04-16 19:57:00',514.0,41
    union all
    select '2022-04-16 21:54:00',622.0,51
    union all
    select '2022-04-16 23:13:00',344.0,42
    union all
    select '2022-04-16 23:22:00',408.0,84
    union all
    select '2022-04-16 23:35:00',120.0,51
    union all
    select '2022-04-17 02:10:00',NULL,50
    union all
    select '2022-04-17 03:02:00',NULL,5
    union all
    select '2022-04-17 03:32:00',NULL,82
    union all
    select '2022-04-17 03:46:00',NULL,93
    union all
    select '2022-04-17 08:05:00',NULL,8
    union all
    select '2022-04-17 09:44:00',NULL,10
    union all
    select '2022-04-17 09:56:00',NULL,86
    union all
    select '2022-04-17 10:02:00',NULL,54
    union all
    select '2022-04-17 11:04:00',NULL,49
    union all
    select '2022-04-17 11:44:00',NULL,76
    union all
    select '2022-04-17 11:51:00',NULL,32
    union all
    select '2022-04-17 12:23:00',NULL,9
    union all
    select '2022-04-17 12:44:00',NULL,70
    union all
    select '2022-04-17 13:26:00',NULL,11
    union all
    select '2022-04-17 13:43:00',NULL,2
    union all
    select '2022-04-17 13:48:00',NULL,87
    union all
    select '2022-04-17 13:52:00',NULL,6
    union all
    select '2022-04-17 17:02:00',NULL,94
    union all
    select '2022-04-17 18:13:00',NULL,91
    union all
    select '2022-04-17 21:16:00',NULL,78
    union all
    select '2022-04-17 22:20:00',NULL,92
    union all
    select '2022-04-18 00:52:00',NULL,12
    union all
    select '2022-04-18 03:10:00',NULL,17
    union all
    select '2022-04-18 04:00:00',NULL,64
    union all
    select '2022-04-18 04:26:00',NULL,51
    union all
    select '2022-04-18 08:10:00',NULL,81
    union all
    select '2022-04-18 09:40:00',NULL,43
    union all
    select '2022-04-18 11:22:00',NULL,41
    union all
    select '2022-04-18 12:53:00',NULL,99
    union all
    select '2022-04-18 14:37:00',NULL,80
    union all
    select '2022-04-18 15:03:00',NULL,77
    union all
    select '2022-04-18 16:13:00',NULL,6
    union all
    select '2022-04-18 17:30:00',NULL,96
    union all
    select '2022-04-18 18:27:00',NULL,29
    union all
    select '2022-04-18 19:48:00',NULL,8
    union all
    select '2022-04-18 20:00:00',NULL,8
    union all
    select '2022-04-18 20:11:00',NULL,92
    union all
    select '2022-04-18 21:55:00',NULL,17
    union all
    select '2022-04-18 23:04:00',NULL,81
    union all
    select '2022-04-18 23:19:00',NULL,34
    union all
    select '2022-04-18 23:20:00',NULL,7
    union all
    select '2022-04-18 23:35:00',NULL,16
    union all
    select '2022-04-18 23:58:00',NULL,69
    union all
    select '2022-04-19 00:53:00',NULL,32
    union all
    select '2022-04-19 02:12:00',NULL,71
    union all
    select '2022-04-19 05:46:00',NULL,18
    union all
    select '2022-04-19 06:41:00',NULL,99
    union all
    select '2022-04-19 06:46:00',NULL,83
    union all
    select '2022-04-19 06:49:00',NULL,95
    union all
    select '2022-04-19 06:56:00',NULL,44
    union all
    select '2022-04-19 10:24:00',NULL,44
    union all
    select '2022-04-19 12:07:00',NULL,80
    union all
    select '2022-04-19 12:21:00',NULL,99
    union all
    select '2022-04-19 13:04:00',NULL,61
    union all
    select '2022-04-19 13:51:00',NULL,73
    union all
    select '2022-04-19 15:08:00',NULL,50
    union all
    select '2022-04-19 18:10:00',NULL,47
    union all
    select '2022-04-19 18:19:00',NULL,63
    union all
    select '2022-04-19 18:52:00',NULL,50
    union all
    select '2022-04-19 19:46:00',NULL,72
    union all
    select '2022-04-19 20:29:00',NULL,17
    union all
    select '2022-04-19 21:07:00',NULL,73
    union all
    select '2022-04-19 22:54:00',NULL,74
    union all
    select '2022-04-20 01:01:00',NULL,43
    union all
    select '2022-04-20 01:48:00',NULL,74
    union all
    select '2022-04-20 02:14:00',NULL,64
    union all
    select '2022-04-20 02:17:00',NULL,8
    union all
    select '2022-04-20 04:12:00',NULL,48
    union all
    select '2022-04-20 04:21:00',NULL,60
    union all
    select '2022-04-20 05:48:00',NULL,8
    union all
    select '2022-04-20 07:10:00',NULL,27
    union all
    select '2022-04-20 08:33:00',NULL,29
    union all
    select '2022-04-20 10:30:00',NULL,39
    union all
    select '2022-04-20 11:10:00',NULL,5
    union all
    select '2022-04-20 13:22:00',NULL,36
    union all
    select '2022-04-20 13:39:00',NULL,58
    union all
    select '2022-04-20 14:38:00',NULL,26
    union all
    select '2022-04-20 14:54:00',NULL,16
    union all
    select '2022-04-20 15:41:00',NULL,53
    union all
    select '2022-04-20 16:01:00',NULL,66
    union all
    select '2022-04-20 17:14:00',NULL,52
    union all
    select '2022-04-20 17:52:00',NULL,25
    union all
    select '2022-04-20 17:54:00',NULL,23
    union all
    select '2022-04-20 18:40:00',NULL,71
    union all
    select '2022-04-20 19:18:00',NULL,24
    union all
    select '2022-04-20 19:24:00',NULL,89
    union all
    select '2022-04-20 20:42:00',NULL,7
    union all
    select '2022-04-20 21:47:00',NULL,89
    union all
    select '2022-04-20 21:52:00',NULL,7
    union all
    select '2022-04-20 23:47:00',NULL,54
    union all
    select '2022-04-21 02:06:00',NULL,47
    union all
    select '2022-04-21 02:12:00',NULL,21
    union all
    select '2022-04-21 04:28:00',NULL,52
    union all
    select '2022-04-21 07:03:00',NULL,74
    union all
    select '2022-04-21 07:13:00',NULL,97
    union all
    select '2022-04-21 08:42:00',NULL,56
    union all
    select '2022-04-21 10:28:00',NULL,39
    union all
    select '2022-04-21 10:57:00',NULL,20
    union all
    select '2022-04-21 11:09:00',NULL,87
    union all
    select '2022-04-21 12:54:00',NULL,84
    union all
    select '2022-04-21 13:43:00',NULL,94
    union all
    select '2022-04-21 15:58:00',NULL,74
    union all
    select '2022-04-21 16:03:00',NULL,99
    union all
    select '2022-04-21 16:19:00',NULL,88
    union all
    select '2022-04-21 19:06:00',NULL,44
    union all
    select '2022-04-21 20:41:00',NULL,54
    union all
    select '2022-04-21 21:18:00',NULL,12
    union all
    select '2022-04-21 22:20:00',NULL,69
    union all
    select '2022-04-21 23:06:00',NULL,63
    union all
    select '2022-04-22 00:12:00',NULL,81
    union all
    select '2022-04-22 00:17:00',NULL,25
    union all
    select '2022-04-22 00:33:00',NULL,10
    union all
    select '2022-04-22 01:13:00',NULL,15
    union all
    select '2022-04-22 01:36:00',NULL,48
    union all
    select '2022-04-22 02:48:00',NULL,37
    union all
    select '2022-04-22 03:29:00',NULL,33
    union all
    select '2022-04-22 03:46:00',NULL,14
    union all
    select '2022-04-22 04:21:00',NULL,42
    union all
    select '2022-04-22 05:53:00',NULL,83
    union all
    select '2022-04-22 06:14:00',NULL,36
    union all
    select '2022-04-22 07:24:00',NULL,25
    union all
    select '2022-04-22 10:45:00',NULL,38
    union all
    select '2022-04-22 11:12:00',NULL,68
    union all
    select '2022-04-22 12:55:00',NULL,92
    union all
    select '2022-04-22 12:59:00',NULL,55
    union all
    select '2022-04-22 14:51:00',NULL,39
    union all
    select '2022-04-22 20:02:00',NULL,68
    union all
    select '2022-04-22 20:36:00',NULL,27
    union all
    select '2022-04-22 20:40:00',NULL,18
    union all
    select '2022-04-22 22:18:00',NULL,41
    union all
    select '2022-04-22 23:20:00',NULL,33
    union all
    select '2022-04-22 23:40:00',NULL,52
    union all
    select '2022-04-23 01:36:00',NULL,89
    union all
    select '2022-04-23 03:53:00',NULL,28
    union all
    select '2022-04-23 04:39:00',NULL,43
    union all
    select '2022-04-23 04:52:00',NULL,18
    union all
    select '2022-04-23 05:06:00',NULL,43
    union all
    select '2022-04-23 05:10:00',NULL,27
    union all
    select '2022-04-23 05:45:00',NULL,13
    union all
    select '2022-04-23 06:21:00',NULL,87
    union all
    select '2022-04-23 07:21:00',NULL,62
    union all
    select '2022-04-23 08:33:00',NULL,31
    union all
    select '2022-04-23 11:31:00',NULL,30
    union all
    select '2022-04-23 11:44:00',NULL,1
    union all
    select '2022-04-23 12:29:00',NULL,19
    union all
    select '2022-04-23 13:33:00',NULL,88
    union all
    select '2022-04-23 14:14:00',NULL,77
    union all
    select '2022-04-23 14:34:00',NULL,69
    union all
    select '2022-04-23 14:46:00',NULL,23
    union all
    select '2022-04-23 20:38:00',NULL,19
    union all
    select '2022-04-23 20:46:00',NULL,90
    union all
    select '2022-04-23 21:51:00',NULL,52
    union all
    select '2022-04-23 22:51:00',NULL,97
    union all
    select '2022-04-23 23:25:00',NULL,91
    union all
    select '2022-04-24 00:31:00',NULL,29
    union all
    select '2022-04-24 00:33:00',NULL,4
    union all
    select '2022-04-24 02:00:00',NULL,95
    union all
    select '2022-04-24 02:02:00',NULL,56
    union all
    select '2022-04-24 02:19:00',NULL,24
    union all
    select '2022-04-24 04:57:00',NULL,3
    union all
    select '2022-04-24 07:50:00',NULL,43
    union all
    select '2022-04-24 08:13:00',NULL,52
    union all
    select '2022-04-24 08:45:00',NULL,14
    union all
    select '2022-04-24 09:06:00',NULL,28
    union all
    select '2022-04-24 09:44:00',NULL,51
    union all
    select '2022-04-24 12:13:00',NULL,32
    union all
    select '2022-04-24 12:17:00',NULL,24
    union all
    select '2022-04-24 12:31:00',NULL,2
    union all
    select '2022-04-24 12:44:00',NULL,9
    union all
    select '2022-04-24 13:18:00',NULL,75
    union all
    select '2022-04-24 13:21:00',NULL,48
    union all
    select '2022-04-24 14:24:00',NULL,95
    union all
    select '2022-04-24 15:09:00',NULL,13
    union all
    select '2022-04-24 18:36:00',NULL,73
    union all
    select '2022-04-24 19:08:00',NULL,30
    union all
    select '2022-04-24 19:19:00',NULL,79
    union all
    select '2022-04-25 00:49:00',988.0,99
    union all
    select '2022-04-25 03:02:00',244.0,70
    union all
    select '2022-04-25 03:05:00',984.0,74
    union all
    select '2022-04-25 03:25:00',530.0,41
    union all
    select '2022-04-25 04:20:00',766.0,7
    union all
    select '2022-04-25 04:37:00',132.0,11
    union all
    select '2022-04-25 05:30:00',210.0,64
    union all
    select '2022-04-25 07:21:00',784.0,13
    union all
    select '2022-04-25 09:08:00',250.0,41
    union all
    select '2022-04-25 10:42:00',178.0,96
    union all
    select '2022-04-25 10:44:00',758.0,6
    union all
    select '2022-04-25 11:32:00',752.0,11
    union all
    select '2022-04-25 12:12:00',138.0,33
    union all
    select '2022-04-25 12:43:00',658.0,20
    union all
    select '2022-04-25 12:48:00',978.0,23
    union all
    select '2022-04-25 13:25:00',466.0,82
    union all
    select '2022-04-25 14:47:00',148.0,6
    union all
    select '2022-04-25 15:22:00',632.0,70
    union all
    select '2022-04-25 15:23:00',458.0,95
    union all
    select '2022-04-25 15:39:00',322.0,96
    union all
    select '2022-04-25 16:35:00',754.0,88
    union all
    select '2022-04-25 19:19:00',998.0,67
    union all
    select '2022-04-25 19:33:00',458.0,49
    union all
    select '2022-04-25 22:22:00',908.0,14
    union all
    select '2022-04-25 22:24:00',478.0,85
    union all
    select '2022-04-25 22:27:00',940.0,84
    union all
    select '2022-04-25 22:43:00',644.0,39
    union all
    select '2022-04-26 00:18:00',998.0,3
    union all
    select '2022-04-26 01:32:00',718.0,11
    union all
    select '2022-04-26 01:36:00',400.0,52
    union all
    select '2022-04-26 02:24:00',542.0,70
    union all
    select '2022-04-26 03:52:00',572.0,24
    union all
    select '2022-04-26 05:01:00',386.0,21
    union all
    select '2022-04-26 05:06:00',170.0,17
    union all
    select '2022-04-26 06:56:00',304.0,7
    union all
    select '2022-04-26 07:07:00',812.0,47
    union all
    select '2022-04-26 08:44:00',226.0,83
    union all
    select '2022-04-26 08:55:00',218.0,46
    union all
    select '2022-04-26 09:29:00',760.0,69
    union all
    select '2022-04-26 09:35:00',928.0,27
    union all
    select '2022-04-26 09:59:00',154.0,99
    union all
    select '2022-04-26 10:17:00',128.0,22
    union all
    select '2022-04-26 10:24:00',762.0,43
    union all
    select '2022-04-26 10:26:00',942.0,52
    union all
    select '2022-04-26 11:36:00',864.0,77
    union all
    select '2022-04-26 12:54:00',362.0,14
    union all
    select '2022-04-26 14:11:00',776.0,38
    union all
    select '2022-04-26 14:53:00',424.0,95
    union all
    select '2022-04-26 15:16:00',630.0,13
    union all
    select '2022-04-26 16:06:00',714.0,39
    union all
    select '2022-04-26 16:43:00',320.0,22
    union all
    select '2022-04-26 18:45:00',560.0,81
    union all
    select '2022-04-26 20:38:00',178.0,30
    union all
    select '2022-04-26 20:47:00',574.0,74
    union all
    select '2022-04-26 21:48:00',910.0,55
    union all
    select '2022-04-26 22:01:00',652.0,88
    union all
    select '2022-04-27 00:14:00',130.0,50
    union all
    select '2022-04-27 01:13:00',112.0,53
    union all
    select '2022-04-27 02:31:00',710.0,21
    union all
    select '2022-04-27 06:17:00',688.0,7
    union all
    select '2022-04-27 06:35:00',560.0,7
    union all
    select '2022-04-27 07:14:00',806.0,77
    union all
    select '2022-04-27 07:40:00',506.0,27
    union all
    select '2022-04-27 08:18:00',532.0,57
    union all
    select '2022-04-27 08:30:00',100.0,29
    union all
    select '2022-04-27 09:09:00',446.0,6
    union all
    select '2022-04-27 09:47:00',268.0,51
    union all
    select '2022-04-27 09:54:00',342.0,98
    union all
    select '2022-04-27 11:00:00',932.0,61
    union all
    select '2022-04-27 11:10:00',670.0,46
    union all
    select '2022-04-27 13:39:00',968.0,14
    union all
    select '2022-04-27 16:36:00',336.0,35
    union all
    select '2022-04-27 17:19:00',174.0,27
    union all
    select '2022-04-27 18:08:00',196.0,42
    union all
    select '2022-04-27 18:17:00',236.0,17
    union all
    select '2022-04-27 19:44:00',444.0,40
    union all
    select '2022-04-27 20:32:00',914.0,90
    union all
    select '2022-04-27 21:08:00',642.0,32
    union all
    select '2022-04-27 21:18:00',300.0,63
    union all
    select '2022-04-27 23:54:00',508.0,61
    union all
    select '2022-04-28 00:16:00',764.0,51
    union all
    select '2022-04-28 00:34:00',926.0,63
    union all
    select '2022-04-28 00:36:00',548.0,49
    union all
    select '2022-04-28 02:14:00',210.0,74
    union all
    select '2022-04-28 02:39:00',734.0,41
    union all
    select '2022-04-28 03:25:00',406.0,44
    union all
    select '2022-04-28 04:11:00',450.0,18
    union all
    select '2022-04-28 05:42:00',154.0,96
    union all
    select '2022-04-28 06:39:00',218.0,71
    union all
    select '2022-04-28 09:56:00',578.0,4
    union all
    select '2022-04-28 11:12:00',776.0,35
    union all
    select '2022-04-28 12:31:00',470.0,60
    union all
    select '2022-04-28 13:08:00',916.0,24
    union all
    select '2022-04-28 14:31:00',844.0,80
    union all
    select '2022-04-28 15:07:00',672.0,31
    union all
    select '2022-04-28 16:02:00',692.0,81
    union all
    select '2022-04-28 20:44:00',504.0,25
    union all
    select '2022-04-28 20:56:00',378.0,72
    union all
    select '2022-04-28 21:12:00',320.0,9
    union all
    select '2022-04-28 22:47:00',370.0,84
    union all
    select '2022-04-28 23:57:00',302.0,93
    union all
    select '2022-04-29 01:05:00',378.0,7
    union all
    select '2022-04-29 02:15:00',578.0,6
    union all
    select '2022-04-29 02:16:00',776.0,65
    union all
    select '2022-04-29 02:53:00',838.0,54
    union all
    select '2022-04-29 04:21:00',146.0,72
    union all
    select '2022-04-29 04:54:00',314.0,8
    union all
    select '2022-04-29 05:41:00',898.0,47
    union all
    select '2022-04-29 06:04:00',732.0,20
    union all
    select '2022-04-29 06:57:00',648.0,10
    union all
    select '2022-04-29 08:49:00',330.0,69
    union all
    select '2022-04-29 11:05:00',342.0,46
    union all
    select '2022-04-29 12:10:00',610.0,8
    union all
    select '2022-04-29 13:48:00',532.0,6
    union all
    select '2022-04-29 14:06:00',970.0,72
    union all
    select '2022-04-29 14:46:00',926.0,58
    union all
    select '2022-04-29 14:52:00',152.0,5
    union all
    select '2022-04-29 15:17:00',464.0,85
    union all
    select '2022-04-29 17:07:00',684.0,72
    union all
    select '2022-04-29 17:21:00',644.0,55
    union all
    select '2022-04-29 17:59:00',834.0,32
    union all
    select '2022-04-29 18:45:00',756.0,47
    union all
    select '2022-04-29 19:00:00',170.0,97
    union all
    select '2022-04-29 19:16:00',642.0,82
    union all
    select '2022-04-29 19:17:00',696.0,84
    union all
    select '2022-04-29 19:25:00',874.0,99
    union all
    select '2022-04-29 21:27:00',586.0,35
    union all
    select '2022-04-29 22:31:00',478.0,20
    union all
    select '2022-04-29 23:20:00',524.0,34
    union all
    select '2022-04-29 23:28:00',698.0,60
    union all
    select '2022-04-29 23:41:00',634.0,69
    union all
    select '2022-04-30 00:31:00',666.0,78
    union all
    select '2022-04-30 01:14:00',162.0,65
    union all
    select '2022-04-30 01:19:00',922.0,76
    union all
    select '2022-04-30 01:44:00',430.0,57
    union all
    select '2022-04-30 04:27:00',752.0,7
    union all
    select '2022-04-30 04:47:00',502.0,23
    union all
    select '2022-04-30 05:22:00',994.0,94
    union all
    select '2022-04-30 05:32:00',714.0,13
    union all
    select '2022-04-30 05:47:00',524.0,76
    union all
    select '2022-04-30 06:23:00',910.0,1
    union all
    select '2022-04-30 10:30:00',758.0,93
    union all
    select '2022-04-30 11:16:00',662.0,15
    union all
    select '2022-04-30 12:12:00',398.0,83
    union all
    select '2022-04-30 12:22:00',874.0,25
    union all
    select '2022-04-30 12:47:00',182.0,39
    union all
    select '2022-04-30 12:51:00',816.0,23
    union all
    select '2022-04-30 14:17:00',120.0,14
    union all
    select '2022-04-30 14:35:00',660.0,11
    union all
    select '2022-04-30 16:26:00',478.0,77
    union all
    select '2022-04-30 18:02:00',770.0,83
    union all
    select '2022-04-30 19:27:00',376.0,68
    union all
    select '2022-04-30 20:39:00',980.0,68
    union all
    select '2022-04-30 21:42:00',940.0,88
    union all
    select '2022-04-30 22:25:00',736.0,84
    union all
    select '2022-04-30 23:21:00',358.0,84
    union all
    select '2022-05-01 01:18:00',564.0,49
    union all
    select '2022-05-01 01:29:00',694.0,23
    union all
    select '2022-05-01 01:37:00',220.0,3
    union all
    select '2022-05-01 03:03:00',978.0,2
    union all
    select '2022-05-01 03:09:00',186.0,63
    union all
    select '2022-05-01 04:01:00',238.0,65
    union all
    select '2022-05-01 05:14:00',810.0,55
    union all
    select '2022-05-01 06:05:00',816.0,43
    union all
    select '2022-05-01 09:00:00',748.0,61
    union all
    select '2022-05-01 09:23:00',998.0,10
    union all
    select '2022-05-01 09:50:00',326.0,96
    union all
    select '2022-05-01 12:15:00',284.0,93
    union all
    select '2022-05-01 12:21:00',828.0,16
    union all
    select '2022-05-01 12:50:00',186.0,46
    union all
    select '2022-05-01 12:59:00',100.0,43
    union all
    select '2022-05-01 14:41:00',626.0,7
    union all
    select '2022-05-01 15:45:00',154.0,43
    union all
    select '2022-05-01 17:38:00',992.0,58
    union all
    select '2022-05-01 18:33:00',760.0,26
    union all
    select '2022-05-01 19:13:00',652.0,28
    union all
    select '2022-05-01 19:21:00',142.0,73
    union all
    select '2022-05-01 23:30:00',642.0,59
    union all
    select '2022-05-02 00:04:00',610.0,99
    union all
    select '2022-05-02 01:08:00',932.0,62
    union all
    select '2022-05-02 03:28:00',202.0,85
    union all
    select '2022-05-02 04:02:00',908.0,31
    union all
    select '2022-05-02 05:19:00',896.0,6
    union all
    select '2022-05-02 05:35:00',188.0,18
    union all
    select '2022-05-02 05:44:00',806.0,82
    union all
    select '2022-05-02 07:27:00',100.0,40
    union all
    select '2022-05-02 07:49:00',970.0,56
    union all
    select '2022-05-02 08:16:00',450.0,84
    union all
    select '2022-05-02 09:00:00',508.0,19
    union all
    select '2022-05-02 09:00:00',492.0,40
    union all
    select '2022-05-02 09:01:00',354.0,55
    union all
    select '2022-05-02 09:29:00',584.0,72
    union all
    select '2022-05-02 09:44:00',268.0,33
    union all
    select '2022-05-02 11:06:00',470.0,84
    union all
    select '2022-05-02 11:50:00',236.0,20
    union all
    select '2022-05-02 11:51:00',236.0,85
    union all
    select '2022-05-02 12:21:00',126.0,2
    union all
    select '2022-05-02 12:41:00',992.0,28
    union all
    select '2022-05-02 13:00:00',170.0,48
    union all
    select '2022-05-02 13:41:00',576.0,99
    union all
    select '2022-05-02 13:47:00',550.0,23
    union all
    select '2022-05-02 13:47:00',144.0,21
    union all
    select '2022-05-02 13:48:00',796.0,5
    union all
    select '2022-05-02 14:15:00',528.0,6
    union all
    select '2022-05-02 14:18:00',382.0,42
    union all
    select '2022-05-02 15:06:00',734.0,81
    union all
    select '2022-05-02 15:52:00',462.0,86
    union all
    select '2022-05-02 17:34:00',838.0,97
    union all
    select '2022-05-02 20:51:00',426.0,32
    union all
    select '2022-05-02 21:33:00',880.0,72
    union all
    select '2022-05-02 23:58:00',606.0,71
    union all
    select '2022-05-03 00:01:00',530.0,30
    union all
    select '2022-05-03 01:34:00',572.0,41
    union all
    select '2022-05-03 02:35:00',498.0,99
    union all
    select '2022-05-03 02:47:00',668.0,70
    union all
    select '2022-05-03 03:53:00',172.0,25
    union all
    select '2022-05-03 04:48:00',346.0,77
    union all
    select '2022-05-03 04:52:00',168.0,37
    union all
    select '2022-05-03 05:56:00',384.0,26
    union all
    select '2022-05-03 07:13:00',154.0,40
    union all
    select '2022-05-03 07:23:00',568.0,30
    union all
    select '2022-05-03 07:38:00',480.0,53
    union all
    select '2022-05-03 07:49:00',648.0,10
    union all
    select '2022-05-03 08:17:00',702.0,92
    union all
    select '2022-05-03 09:21:00',194.0,56
    union all
    select '2022-05-03 09:22:00',344.0,65
    union all
    select '2022-05-03 11:15:00',670.0,10
    union all
    select '2022-05-03 11:21:00',550.0,16
    union all
    select '2022-05-03 14:45:00',518.0,4
    union all
    select '2022-05-03 15:17:00',390.0,32
    union all
    select '2022-05-03 17:47:00',582.0,76
    union all
    select '2022-05-03 18:48:00',624.0,82
    union all
    select '2022-05-03 19:35:00',236.0,77
    union all
    select '2022-05-03 21:27:00',564.0,79
    union all
    select '2022-05-03 22:37:00',414.0,20
    union all
    select '2022-05-03 23:24:00',960.0,64
    union all
    select '2022-05-03 23:25:00',794.0,78
    union all
    select '2022-05-04 00:39:00',896.0,66
    union all
    select '2022-05-04 02:27:00',882.0,96
    union all
    select '2022-05-04 03:03:00',838.0,50
    union all
    select '2022-05-04 04:03:00',986.0,48
    union all
    select '2022-05-04 05:16:00',716.0,77
    union all
    select '2022-05-04 06:26:00',166.0,95
    union all
    select '2022-05-04 07:46:00',158.0,88
    union all
    select '2022-05-04 08:39:00',352.0,20
    union all
    select '2022-05-04 09:39:00',404.0,34
    union all
    select '2022-05-04 11:19:00',140.0,63
    union all
    select '2022-05-04 11:48:00',496.0,35
    union all
    select '2022-05-04 12:42:00',772.0,65
    union all
    select '2022-05-04 13:44:00',610.0,85
    union all
    select '2022-05-04 13:49:00',526.0,66
    union all
    select '2022-05-04 14:49:00',148.0,30
    union all
    select '2022-05-04 17:10:00',132.0,69
    union all
    select '2022-05-04 17:38:00',332.0,44
    union all
    select '2022-05-04 18:38:00',126.0,70
    union all
    select '2022-05-04 18:57:00',534.0,99
    union all
    select '2022-05-04 20:49:00',754.0,29
    union all
    select '2022-05-04 21:43:00',592.0,31
    union all
    select '2022-05-04 21:48:00',656.0,32
    union all
    select '2022-05-04 23:30:00',466.0,26
    union all
    select '2022-05-04 23:33:00',322.0,51
    union all
    select '2022-05-05 01:37:00',846.0,49
    union all
    select '2022-05-05 03:18:00',966.0,32
    union all
    select '2022-05-05 03:31:00',168.0,34
    union all
    select '2022-05-05 03:39:00',604.0,19
    union all
    select '2022-05-05 05:22:00',576.0,30
    union all
    select '2022-05-05 05:27:00',530.0,76
    union all
    select '2022-05-05 06:26:00',726.0,26
    union all
    select '2022-05-05 09:33:00',264.0,68
    union all
    select '2022-05-05 11:48:00',916.0,69
    union all
    select '2022-05-05 12:49:00',110.0,76
    union all
    select '2022-05-05 12:50:00',888.0,24
    union all
    select '2022-05-05 13:07:00',288.0,40
    union all
    select '2022-05-05 13:40:00',848.0,70
    union all
    select '2022-05-05 13:44:00',580.0,6
    union all
    select '2022-05-05 14:22:00',648.0,88
    union all
    select '2022-05-05 15:58:00',420.0,59
    union all
    select '2022-05-05 16:58:00',422.0,68
    union all
    select '2022-05-05 17:48:00',322.0,43
    union all
    select '2022-05-05 18:17:00',220.0,99
    union all
    select '2022-05-05 18:50:00',850.0,19
    union all
    select '2022-05-05 18:55:00',528.0,1
    union all
    select '2022-05-05 19:34:00',794.0,47
    union all
    select '2022-05-05 20:36:00',100.0,36
    union all
    select '2022-05-05 21:41:00',624.0,10
    union all
    select '2022-05-05 22:55:00',478.0,48
    union all
    select '2022-05-06 03:32:00',834.0,57
    union all
    select '2022-05-06 03:41:00',452.0,35
    union all
    select '2022-05-06 04:11:00',370.0,83
    union all
    select '2022-05-06 06:28:00',376.0,73
    union all
    select '2022-05-06 08:33:00',244.0,1
    union all
    select '2022-05-06 09:00:00',188.0,38
    union all
    select '2022-05-06 09:30:00',508.0,3
    union all
    select '2022-05-06 09:47:00',826.0,49
    union all
    select '2022-05-06 10:58:00',458.0,7
    union all
    select '2022-05-06 11:14:00',156.0,92
    union all
    select '2022-05-06 12:39:00',712.0,92
    union all
    select '2022-05-06 12:43:00',468.0,65
    union all
    select '2022-05-06 16:48:00',844.0,52
    union all
    select '2022-05-06 17:27:00',474.0,94
    union all
    select '2022-05-06 17:48:00',272.0,44
    union all
    select '2022-05-06 18:35:00',972.0,91
    union all
    select '2022-05-06 18:43:00',106.0,89
    union all
    select '2022-05-06 20:57:00',346.0,86
    union all
    select '2022-05-06 21:58:00',372.0,83
    union all
    select '2022-05-07 00:29:00',192.0,23
    union all
    select '2022-05-07 01:33:00',742.0,39
    union all
    select '2022-05-07 02:18:00',944.0,54
    union all
    select '2022-05-07 05:33:00',700.0,55
    union all
    select '2022-05-07 08:14:00',670.0,21
    union all
    select '2022-05-07 10:18:00',760.0,83
    union all
    select '2022-05-07 10:44:00',350.0,59
    union all
    select '2022-05-07 11:17:00',654.0,40
    union all
    select '2022-05-07 15:25:00',846.0,19
    union all
    select '2022-05-07 15:39:00',420.0,38
    union all
    select '2022-05-07 15:59:00',164.0,84
    union all
    select '2022-05-07 16:14:00',520.0,22
    union all
    select '2022-05-07 17:51:00',268.0,31
    union all
    select '2022-05-07 18:40:00',542.0,29
    union all
    select '2022-05-07 18:56:00',884.0,35
    union all
    select '2022-05-07 18:58:00',230.0,74
    union all
    select '2022-05-07 19:48:00',100.0,35
    union all
    select '2022-05-07 19:49:00',962.0,18
    union all
    select '2022-05-07 20:12:00',574.0,70
    union all
    select '2022-05-07 20:58:00',704.0,36
    union all
    select '2022-05-07 21:36:00',574.0,88
    union all
    select '2022-05-07 22:40:00',816.0,96
    union all
    select '2022-05-07 23:17:00',646.0,9
    union all
    select '2022-05-08 00:15:00',488.0,18
    union all
    select '2022-05-08 01:28:00',214.0,2
    union all
    select '2022-05-08 02:08:00',524.0,41
    union all
    select '2022-05-08 02:52:00',182.0,99
    union all
    select '2022-05-08 03:35:00',874.0,89
    union all
    select '2022-05-08 05:35:00',468.0,12
    union all
    select '2022-05-08 06:34:00',810.0,90
    union all
    select '2022-05-08 07:09:00',410.0,87
    union all
    select '2022-05-08 07:34:00',364.0,65
    union all
    select '2022-05-08 08:00:00',354.0,67
    union all
    select '2022-05-08 08:25:00',356.0,98
    union all
    select '2022-05-08 09:07:00',204.0,72
    union all
    select '2022-05-08 10:48:00',492.0,79
    union all
    select '2022-05-08 14:00:00',836.0,17
    union all
    select '2022-05-08 14:42:00',634.0,63
    union all
    select '2022-05-08 15:29:00',602.0,45
    union all
    select '2022-05-08 15:32:00',766.0,58
    union all
    select '2022-05-08 18:27:00',176.0,69
    union all
    select '2022-05-08 18:56:00',574.0,51
    union all
    select '2022-05-08 22:05:00',410.0,93
    union all
    select '2022-05-08 22:11:00',154.0,56
    union all
    select '2022-05-08 22:52:00',486.0,86
    union all
    select '2022-05-08 23:12:00',270.0,24
    union all
    select '2022-05-09 00:50:00',912.0,91
    union all
    select '2022-05-09 01:26:00',412.0,44
    union all
    select '2022-05-09 01:57:00',704.0,83
    union all
    select '2022-05-09 02:09:00',718.0,63
    union all
    select '2022-05-09 02:38:00',782.0,87
    union all
    select '2022-05-09 04:52:00',588.0,83
    union all
    select '2022-05-09 05:28:00',590.0,6
    union all
    select '2022-05-09 07:02:00',208.0,3
    union all
    select '2022-05-09 07:14:00',346.0,35
    union all
    select '2022-05-09 07:19:00',270.0,24
    union all
    select '2022-05-09 07:41:00',678.0,6
    union all
    select '2022-05-09 08:30:00',640.0,96
    union all
    select '2022-05-09 08:36:00',228.0,93
    union all
    select '2022-05-09 08:40:00',660.0,55
    union all
    select '2022-05-09 08:49:00',630.0,34
    union all
    select '2022-05-09 11:08:00',288.0,75
    union all
    select '2022-05-09 11:09:00',896.0,73
    union all
    select '2022-05-09 12:47:00',636.0,16
    union all
    select '2022-05-09 14:26:00',462.0,85
    union all
    select '2022-05-09 15:02:00',788.0,94
    union all
    select '2022-05-09 17:48:00',546.0,17
    union all
    select '2022-05-09 18:10:00',192.0,97
    union all
    select '2022-05-09 21:40:00',618.0,20
    union all
    select '2022-05-09 23:14:00',722.0,13
    union all
    select '2022-05-10 00:10:00',116.0,70
    union all
    select '2022-05-10 00:57:00',580.0,84
    union all
    select '2022-05-10 01:29:00',820.0,10
    union all
    select '2022-05-10 02:25:00',278.0,9
    union all
    select '2022-05-10 03:27:00',726.0,80
    union all
    select '2022-05-10 03:36:00',820.0,95
    union all
    select '2022-05-10 03:54:00',526.0,22
    union all
    select '2022-05-10 04:22:00',738.0,32
    union all
    select '2022-05-10 05:09:00',382.0,55
    union all
    select '2022-05-10 05:13:00',926.0,64
    union all
    select '2022-05-10 05:37:00',758.0,35
    union all
    select '2022-05-10 05:38:00',860.0,91
    union all
    select '2022-05-10 05:58:00',614.0,77
    union all
    select '2022-05-10 07:22:00',848.0,5
    union all
    select '2022-05-10 08:03:00',846.0,78
    union all
    select '2022-05-10 09:16:00',790.0,60
    union all
    select '2022-05-10 10:43:00',338.0,33
    union all
    select '2022-05-10 14:20:00',206.0,84
    union all
    select '2022-05-10 16:10:00',706.0,83
    union all
    select '2022-05-10 16:29:00',460.0,14
    union all
    select '2022-05-10 18:38:00',960.0,78
    union all
    select '2022-05-10 18:44:00',704.0,56
    union all
    select '2022-05-10 18:53:00',286.0,55
    union all
    select '2022-05-10 18:55:00',332.0,63
    union all
    select '2022-05-10 19:02:00',128.0,74
    union all
    select '2022-05-10 19:12:00',292.0,89
    union all
    select '2022-05-10 19:14:00',574.0,72
    union all
    select '2022-05-10 22:01:00',302.0,66
    union all
    select '2022-05-10 22:36:00',846.0,58
    union all
    select '2022-05-10 22:56:00',278.0,31
    union all
    select '2022-05-10 23:15:00',480.0,91
    union all
    select '2022-05-11 00:54:00',750.0,11
    union all
    select '2022-05-11 01:59:00',112.0,8
    union all
    select '2022-05-11 02:12:00',676.0,38
    union all
    select '2022-05-11 02:22:00',370.0,41
    union all
    select '2022-05-11 02:31:00',796.0,54
    union all
    select '2022-05-11 02:50:00',914.0,11
    union all
    select '2022-05-11 03:09:00',172.0,84
    union all
    select '2022-05-11 03:42:00',158.0,88
    union all
    select '2022-05-11 03:45:00',322.0,22
    union all
    select '2022-05-11 04:00:00',740.0,26
    union all
    select '2022-05-11 06:34:00',392.0,43
    union all
    select '2022-05-11 06:48:00',978.0,46
    union all
    select '2022-05-11 07:06:00',884.0,74
    union all
    select '2022-05-11 07:58:00',356.0,90
    union all
    select '2022-05-11 08:06:00',582.0,57
    union all
    select '2022-05-11 08:28:00',644.0,43
    union all
    select '2022-05-11 08:40:00',248.0,28
    union all
    select '2022-05-11 11:43:00',472.0,76
    union all
    select '2022-05-11 11:58:00',302.0,10
    union all
    select '2022-05-11 12:20:00',800.0,3
    union all
    select '2022-05-11 12:27:00',138.0,21
    union all
    select '2022-05-11 12:35:00',820.0,54
    union all
    select '2022-05-11 12:36:00',938.0,15
    union all
    select '2022-05-11 15:18:00',578.0,57
    union all
    select '2022-05-11 15:20:00',476.0,91
    union all
    select '2022-05-11 15:26:00',682.0,49
    union all
    select '2022-05-11 15:44:00',728.0,9
    union all
    select '2022-05-11 15:54:00',100.0,36
    union all
    select '2022-05-11 17:30:00',162.0,26
    union all
    select '2022-05-11 17:37:00',334.0,7
    union all
    select '2022-05-11 19:11:00',226.0,96
    union all
    select '2022-05-11 19:18:00',750.0,28
    union all
    select '2022-05-11 20:30:00',750.0,22
    union all
    select '2022-05-11 20:46:00',998.0,51
    union all
    select '2022-05-11 20:48:00',412.0,61
    union all
    select '2022-05-11 21:40:00',730.0,32
    union all
    select '2022-05-11 22:32:00',110.0,24
    union all
    select '2022-05-12 00:27:00',110.0,48
    union all
    select '2022-05-12 01:34:00',920.0,81
    union all
    select '2022-05-12 04:10:00',668.0,67
    union all
    select '2022-05-12 04:14:00',594.0,24
    union all
    select '2022-05-12 04:31:00',620.0,72
    union all
    select '2022-05-12 04:53:00',836.0,22
    union all
    select '2022-05-12 05:53:00',796.0,33
    union all
    select '2022-05-12 07:04:00',662.0,47
    union all
    select '2022-05-12 08:17:00',394.0,24
    union all
    select '2022-05-12 09:47:00',748.0,79
    union all
    select '2022-05-12 10:18:00',910.0,74
    union all
    select '2022-05-12 10:27:00',144.0,43
    union all
    select '2022-05-12 10:33:00',990.0,98
    union all
    select '2022-05-12 11:22:00',134.0,17
    union all
    select '2022-05-12 12:32:00',654.0,74
    union all
    select '2022-05-12 14:14:00',814.0,15
    union all
    select '2022-05-12 14:55:00',166.0,82
    union all
    select '2022-05-12 15:23:00',708.0,88
    union all
    select '2022-05-12 15:45:00',876.0,33
    union all
    select '2022-05-12 16:00:00',442.0,28
    union all
    select '2022-05-12 16:19:00',720.0,72
    union all
    select '2022-05-12 16:45:00',818.0,58
    union all
    select '2022-05-12 17:02:00',296.0,57
    union all
    select '2022-05-12 17:07:00',100.0,65
    union all
    select '2022-05-12 18:08:00',446.0,54
    union all
    select '2022-05-12 18:11:00',324.0,36
    union all
    select '2022-05-12 18:22:00',982.0,81
    union all
    select '2022-05-12 19:35:00',274.0,27
    union all
    select '2022-05-12 20:55:00',228.0,39
    union all
    select '2022-05-12 20:56:00',508.0,69
    union all
    select '2022-05-12 21:06:00',556.0,67
    union all
    select '2022-05-12 22:44:00',578.0,50
    union all
    select '2022-05-12 22:49:00',568.0,48
    union all
    select '2022-05-13 00:19:00',470.0,50
    union all
    select '2022-05-13 00:34:00',532.0,23
    union all
    select '2022-05-13 01:07:00',804.0,94
    union all
    select '2022-05-13 01:54:00',114.0,77
    union all
    select '2022-05-13 02:38:00',576.0,90
    union all
    select '2022-05-13 03:15:00',542.0,64
    union all
    select '2022-05-13 04:35:00',778.0,84
    union all
    select '2022-05-13 06:53:00',836.0,11
    union all
    select '2022-05-13 06:56:00',260.0,47
    union all
    select '2022-05-13 07:02:00',862.0,67
    union all
    select '2022-05-13 07:02:00',550.0,54
    union all
    select '2022-05-13 08:35:00',554.0,56
    union all
    select '2022-05-13 09:04:00',650.0,99
    union all
    select '2022-05-13 10:40:00',430.0,29
    union all
    select '2022-05-13 12:15:00',400.0,78
    union all
    select '2022-05-13 12:34:00',674.0,64
    union all
    select '2022-05-13 12:48:00',802.0,48
    union all
    select '2022-05-13 12:50:00',436.0,11
    union all
    select '2022-05-13 13:13:00',330.0,93
    union all
    select '2022-05-13 14:57:00',558.0,27
    union all
    select '2022-05-13 15:43:00',378.0,87
    union all
    select '2022-05-13 17:11:00',564.0,95
    union all
    select '2022-05-13 18:05:00',306.0,91
    union all
    select '2022-05-13 19:47:00',774.0,76
    union all
    select '2022-05-13 20:52:00',180.0,92
    union all
    select '2022-05-13 21:16:00',328.0,2
    union all
    select '2022-05-13 23:17:00',226.0,65
    union all
    select '2022-05-14 00:27:00',646.0,8
    union all
    select '2022-05-14 01:44:00',492.0,19
    union all
    select '2022-05-14 02:49:00',966.0,28
    union all
    select '2022-05-14 03:15:00',136.0,65
    union all
    select '2022-05-14 04:02:00',628.0,1
    union all
    select '2022-05-14 05:22:00',904.0,21
    union all
    select '2022-05-14 05:33:00',742.0,58
    union all
    select '2022-05-14 05:54:00',852.0,16
    union all
    select '2022-05-14 05:55:00',270.0,77
    union all
    select '2022-05-14 06:19:00',226.0,56
    union all
    select '2022-05-14 06:22:00',906.0,43
    union all
    select '2022-05-14 07:07:00',230.0,58
    union all
    select '2022-05-14 08:28:00',648.0,41
    union all
    select '2022-05-14 09:11:00',610.0,46
    union all
    select '2022-05-14 10:30:00',650.0,23
    union all
    select '2022-05-14 13:09:00',406.0,58
    union all
    select '2022-05-14 13:33:00',182.0,7
    union all
    select '2022-05-14 14:47:00',996.0,87
    union all
    select '2022-05-14 14:49:00',658.0,83
    union all
    select '2022-05-14 15:59:00',562.0,16
    union all
    select '2022-05-14 17:07:00',348.0,20
    union all
    select '2022-05-14 18:53:00',194.0,53
    union all
    select '2022-05-14 19:02:00',138.0,52
    union all
    select '2022-05-14 21:35:00',634.0,11
    union all
    select '2022-05-14 22:00:00',532.0,46
    union all
    select '2022-05-14 22:05:00',664.0,47
    union all
    select '2022-05-14 22:45:00',732.0,21
    union all
    select '2022-05-15 00:18:00',892.0,49
    union all
    select '2022-05-15 01:03:00',686.0,32
    union all
    select '2022-05-15 01:54:00',886.0,98
    union all
    select '2022-05-15 07:00:00',478.0,41
    union all
    select '2022-05-15 07:09:00',694.0,41
    union all
    select '2022-05-15 07:14:00',792.0,8
    union all
    select '2022-05-15 09:20:00',152.0,14
    union all
    select '2022-05-15 10:11:00',714.0,19
    union all
    select '2022-05-15 10:42:00',356.0,13
    union all
    select '2022-05-15 10:43:00',464.0,80
    union all
    select '2022-05-15 11:53:00',762.0,83
    union all
    select '2022-05-15 12:03:00',868.0,55
    union all
    select '2022-05-15 13:12:00',502.0,83
    union all
    select '2022-05-15 14:11:00',422.0,32
    union all
    select '2022-05-15 14:33:00',374.0,11
    union all
    select '2022-05-15 14:46:00',126.0,97
    union all
    select '2022-05-15 17:03:00',800.0,43
    union all
    select '2022-05-15 17:12:00',250.0,93
    union all
    select '2022-05-15 18:03:00',456.0,73
    union all
    select '2022-05-15 18:27:00',996.0,54
    union all
    select '2022-05-15 18:38:00',660.0,3
    union all
    select '2022-05-15 20:01:00',956.0,7
    union all
    select '2022-05-15 20:33:00',876.0,40
    union all
    select '2022-05-15 22:15:00',202.0,5
    union all
    select '2022-05-15 23:26:00',742.0,7
    union all
    select '2022-05-15 23:58:00',670.0,47
    union all
    select '2022-05-16 00:55:00',222.0,55
    union all
    select '2022-05-16 02:07:00',106.0,21
    union all
    select '2022-05-16 02:10:00',148.0,47
    union all
    select '2022-05-16 02:41:00',656.0,94
    union all
    select '2022-05-16 02:44:00',512.0,16
    union all
    select '2022-05-16 02:52:00',650.0,74
    union all
    select '2022-05-16 03:29:00',582.0,1
    union all
    select '2022-05-16 04:04:00',434.0,56
    union all
    select '2022-05-16 05:01:00',956.0,9
    union all
    select '2022-05-16 06:41:00',794.0,53
    union all
    select '2022-05-16 06:54:00',700.0,60
    union all
    select '2022-05-16 07:40:00',806.0,88
    union all
    select '2022-05-16 08:00:00',838.0,84
    union all
    select '2022-05-16 08:08:00',674.0,43
    union all
    select '2022-05-16 08:37:00',772.0,30
    union all
    select '2022-05-16 10:48:00',378.0,8
    union all
    select '2022-05-16 11:09:00',904.0,58
    union all
    select '2022-05-16 11:58:00',660.0,50
    union all
    select '2022-05-16 15:17:00',904.0,3
    union all
    select '2022-05-16 15:51:00',996.0,81
    union all
    select '2022-05-16 16:07:00',746.0,17
    union all
    select '2022-05-16 17:06:00',538.0,62
    union all
    select '2022-05-16 19:13:00',682.0,13
    union all
    select '2022-05-16 21:59:00',550.0,27
    union all
    select '2022-05-16 22:15:00',900.0,5
    union all
    select '2022-05-16 23:02:00',140.0,61
    union all
    select '2022-05-16 23:08:00',428.0,1
    union all
    select '2022-05-17 00:54:00',220.0,1
    union all
    select '2022-05-17 01:44:00',390.0,92
    union all
    select '2022-05-17 02:35:00',618.0,68
    union all
    select '2022-05-17 04:11:00',276.0,26
    union all
    select '2022-05-17 06:05:00',118.0,53
    union all
    select '2022-05-17 06:34:00',352.0,48
    union all
    select '2022-05-17 06:51:00',382.0,5
    union all
    select '2022-05-17 06:56:00',380.0,41
    union all
    select '2022-05-17 07:43:00',202.0,76
    union all
    select '2022-05-17 08:03:00',892.0,97
    union all
    select '2022-05-17 09:16:00',296.0,90
    union all
    select '2022-05-17 09:45:00',242.0,1
    union all
    select '2022-05-17 10:46:00',262.0,74
    union all
    select '2022-05-17 11:46:00',168.0,23
    union all
    select '2022-05-17 12:36:00',532.0,90
    union all
    select '2022-05-17 12:37:00',996.0,92
    union all
    select '2022-05-17 12:47:00',584.0,55
    union all
    select '2022-05-17 13:36:00',604.0,55
    union all
    select '2022-05-17 13:44:00',388.0,93
    union all
    select '2022-05-17 14:12:00',988.0,87
    union all
    select '2022-05-17 14:34:00',100.0,18
    union all
    select '2022-05-17 15:19:00',310.0,14
    union all
    select '2022-05-17 15:56:00',456.0,18
    union all
    select '2022-05-17 16:33:00',206.0,26
    union all
    select '2022-05-17 21:20:00',348.0,33
    union all
    select '2022-05-17 21:22:00',226.0,70
    union all
    select '2022-05-17 21:56:00',354.0,10
    union all
    select '2022-05-17 22:05:00',180.0,70
    union all
    select '2022-05-17 22:57:00',332.0,68
    union all
    select '2022-05-17 23:11:00',872.0,78
    union all
    select '2022-05-17 23:42:00',432.0,28
    union all
    select '2022-05-18 00:18:00',784.0,71
    union all
    select '2022-05-18 06:56:00',172.0,29
    union all
    select '2022-05-18 07:23:00',476.0,1
    union all
    select '2022-05-18 10:21:00',676.0,51
    union all
    select '2022-05-18 12:03:00',752.0,64
    union all
    select '2022-05-18 12:39:00',832.0,30
    union all
    select '2022-05-18 13:26:00',564.0,58
    union all
    select '2022-05-18 13:40:00',582.0,62
    union all
    select '2022-05-18 14:14:00',542.0,50
    union all
    select '2022-05-18 15:45:00',268.0,64
    union all
    select '2022-05-18 16:26:00',380.0,95
    union all
    select '2022-05-18 17:50:00',266.0,9
    union all
    select '2022-05-18 18:30:00',310.0,66
    union all
    select '2022-05-18 19:20:00',692.0,68
    union all
    select '2022-05-18 19:45:00',534.0,98
    union all
    select '2022-05-18 19:57:00',712.0,63
    union all
    select '2022-05-18 20:56:00',600.0,73
    union all
    select '2022-05-18 21:00:00',418.0,27
    union all
    select '2022-05-18 21:12:00',954.0,40
    union all
    select '2022-05-19 00:22:00',750.0,56
    union all
    select '2022-05-19 00:53:00',950.0,50
    union all
    select '2022-05-19 02:57:00',572.0,97
    union all
    select '2022-05-19 04:08:00',224.0,24
    union all
    select '2022-05-19 04:11:00',918.0,64
    union all
    select '2022-05-19 08:10:00',398.0,66
    union all
    select '2022-05-19 10:28:00',170.0,93
    union all
    select '2022-05-19 10:51:00',232.0,35
    union all
    select '2022-05-19 11:03:00',430.0,57
    union all
    select '2022-05-19 12:16:00',680.0,44
    union all
    select '2022-05-19 12:41:00',660.0,89
    union all
    select '2022-05-19 13:21:00',776.0,13
    union all
    select '2022-05-19 14:21:00',260.0,75
    union all
    select '2022-05-19 14:37:00',500.0,42
    union all
    select '2022-05-19 16:35:00',700.0,64
    union all
    select '2022-05-19 17:59:00',692.0,59
    union all
    select '2022-05-19 21:43:00',430.0,38
    union all
    select '2022-05-19 22:41:00',940.0,54
    union all
    select '2022-05-20 00:26:00',572.0,40
    union all
    select '2022-05-20 01:14:00',564.0,6
    union all
    select '2022-05-20 02:14:00',162.0,9
    union all
    select '2022-05-20 02:22:00',512.0,35
    union all
    select '2022-05-20 03:14:00',858.0,77
    union all
    select '2022-05-20 03:57:00',292.0,87
    union all
    select '2022-05-20 04:00:00',352.0,37
    union all
    select '2022-05-20 04:03:00',600.0,77
    union all
    select '2022-05-20 08:08:00',518.0,73
    union all
    select '2022-05-20 08:28:00',422.0,81
    union all
    select '2022-05-20 08:56:00',336.0,70
    union all
    select '2022-05-20 14:04:00',320.0,39
    union all
    select '2022-05-20 14:20:00',228.0,98
    union all
    select '2022-05-20 16:27:00',834.0,37
    union all
    select '2022-05-20 16:51:00',418.0,31
    union all
    select '2022-05-20 17:31:00',276.0,21
    union all
    select '2022-05-20 17:31:00',384.0,56
    union all
    select '2022-05-20 17:49:00',288.0,15
    union all
    select '2022-05-20 18:28:00',630.0,77
    union all
    select '2022-05-20 19:57:00',138.0,78
    union all
    select '2022-05-20 22:00:00',960.0,28
    union all
    select '2022-05-20 22:18:00',342.0,28
    union all
    select '2022-05-20 22:53:00',566.0,60
    union all
    select '2022-05-20 22:59:00',636.0,36
    union all
    select '2022-05-20 23:59:00',254.0,7
    union all
    select '2022-05-21 00:09:00',814.0,45
    union all
    select '2022-05-21 01:26:00',312.0,10
    union all
    select '2022-05-21 01:39:00',370.0,10
    union all
    select '2022-05-21 02:04:00',160.0,95
    union all
    select '2022-05-21 09:24:00',138.0,25
    union all
    select '2022-05-21 09:39:00',352.0,64
    union all
    select '2022-05-21 11:06:00',662.0,21
    union all
    select '2022-05-21 13:06:00',510.0,19
    union all
    select '2022-05-21 17:07:00',112.0,80
    union all
    select '2022-05-21 17:29:00',748.0,2
    union all
    select '2022-05-21 18:08:00',728.0,62
    union all
    select '2022-05-21 19:07:00',226.0,2
    union all
    select '2022-05-21 19:20:00',192.0,17
    union all
    select '2022-05-21 20:06:00',564.0,48
    union all
    select '2022-05-21 21:18:00',440.0,63
    union all
    select '2022-05-21 22:28:00',230.0,26
    union all
    select '2022-05-21 23:27:00',736.0,99
    union all
    select '2022-05-22 01:46:00',494.0,61
    union all
    select '2022-05-22 03:50:00',824.0,51
    union all
    select '2022-05-22 04:23:00',468.0,71
    union all
    select '2022-05-22 04:36:00',680.0,6
    union all
    select '2022-05-22 05:24:00',606.0,5
    union all
    select '2022-05-22 08:49:00',716.0,15
    union all
    select '2022-05-22 09:54:00',664.0,77
    union all
    select '2022-05-22 12:20:00',674.0,42
    union all
    select '2022-05-22 12:28:00',502.0,83
    union all
    select '2022-05-22 13:16:00',362.0,44
    union all
    select '2022-05-22 15:30:00',694.0,38
    union all
    select '2022-05-22 17:49:00',536.0,23
    union all
    select '2022-05-22 18:02:00',780.0,63
    union all
    select '2022-05-22 19:49:00',370.0,15
    union all
    select '2022-05-22 21:37:00',424.0,50
    union all
    select '2022-05-22 23:06:00',226.0,78
    union all
    select '2022-05-22 23:32:00',620.0,35
    union all
    select '2022-05-22 23:59:00',488.0,93
    union all
    select '2022-05-23 01:28:00',894.0,66
    union all
    select '2022-05-23 01:30:00',550.0,71
    union all
    select '2022-05-23 02:22:00',716.0,70
    union all
    select '2022-05-23 02:28:00',408.0,8
    union all
    select '2022-05-23 03:08:00',680.0,68
    union all
    select '2022-05-23 04:11:00',170.0,93
    union all
    select '2022-05-23 04:27:00',404.0,68
    union all
    select '2022-05-23 04:40:00',274.0,69
    union all
    select '2022-05-23 05:49:00',598.0,31
    union all
    select '2022-05-23 08:17:00',954.0,27
    union all
    select '2022-05-23 08:17:00',754.0,3
    union all
    select '2022-05-23 12:12:00',868.0,22
    union all
    select '2022-05-23 13:16:00',352.0,12
    union all
    select '2022-05-23 13:21:00',430.0,40
    union all
    select '2022-05-23 14:32:00',786.0,28
    union all
    select '2022-05-23 18:05:00',414.0,34
    union all
    select '2022-05-23 18:44:00',296.0,31
    union all
    select '2022-05-23 20:55:00',188.0,98
    union all
    select '2022-05-23 21:56:00',378.0,21
    union all
    select '2022-05-23 22:05:00',254.0,27
    union all
    select '2022-05-23 22:37:00',892.0,14
    union all
    select '2022-05-23 23:21:00',712.0,84
    union all
    select '2022-05-24 00:30:00',148.0,62
    union all
    select '2022-05-24 00:44:00',746.0,22
    union all
    select '2022-05-24 00:44:00',216.0,49
    union all
    select '2022-05-24 00:51:00',224.0,76
    union all
    select '2022-05-24 01:01:00',758.0,30
    union all
    select '2022-05-24 01:21:00',194.0,60
    union all
    select '2022-05-24 01:24:00',982.0,18
    union all
    select '2022-05-24 02:11:00',206.0,12
    union all
    select '2022-05-24 04:10:00',684.0,93
    union all
    select '2022-05-24 05:00:00',588.0,74
    union all
    select '2022-05-24 05:11:00',494.0,97
    union all
    select '2022-05-24 05:35:00',324.0,56
    union all
    select '2022-05-24 05:38:00',576.0,27
    union all
    select '2022-05-24 06:05:00',164.0,35
    union all
    select '2022-05-24 07:25:00',496.0,52
    union all
    select '2022-05-24 07:58:00',308.0,28
    union all
    select '2022-05-24 10:48:00',740.0,67
    union all
    select '2022-05-24 10:54:00',178.0,47
    union all
    select '2022-05-24 11:28:00',940.0,4
    union all
    select '2022-05-24 12:33:00',308.0,65
    union all
    select '2022-05-24 12:51:00',536.0,3
    union all
    select '2022-05-24 13:14:00',554.0,49
    union all
    select '2022-05-24 13:18:00',236.0,29
    union all
    select '2022-05-24 14:25:00',422.0,72
    union all
    select '2022-05-24 14:34:00',602.0,56
    union all
    select '2022-05-24 15:27:00',878.0,80
    union all
    select '2022-05-24 15:50:00',918.0,21
    union all
    select '2022-05-24 16:00:00',436.0,5
    union all
    select '2022-05-24 16:55:00',528.0,35
    union all
    select '2022-05-24 18:34:00',908.0,17
    union all
    select '2022-05-24 19:15:00',524.0,51
    union all
    select '2022-05-24 20:10:00',166.0,9
    union all
    select '2022-05-24 21:48:00',514.0,75
    union all
    select '2022-05-25 00:18:00',616.0,53
    union all
    select '2022-05-25 01:21:00',700.0,76
    union all
    select '2022-05-25 02:09:00',716.0,12
    union all
    select '2022-05-25 02:27:00',228.0,91
    union all
    select '2022-05-25 02:30:00',892.0,96
    union all
    select '2022-05-25 02:30:00',710.0,31
    union all
    select '2022-05-25 04:39:00',190.0,83
    union all
    select '2022-05-25 04:41:00',300.0,12
    union all
    select '2022-05-25 05:21:00',238.0,15
    union all
    select '2022-05-25 06:06:00',644.0,44
    union all
    select '2022-05-25 07:39:00',322.0,61
    union all
    select '2022-05-25 07:50:00',550.0,64
    union all
    select '2022-05-25 08:12:00',258.0,69
    union all
    select '2022-05-25 08:16:00',642.0,64
    union all
    select '2022-05-25 08:54:00',284.0,31
    union all
    select '2022-05-25 10:38:00',788.0,1
    union all
    select '2022-05-25 13:00:00',660.0,72
    union all
    select '2022-05-25 13:35:00',798.0,94
    union all
    select '2022-05-25 17:25:00',380.0,56
    union all
    select '2022-05-25 17:37:00',848.0,36
    union all
    select '2022-05-25 18:58:00',418.0,54
    union all
    select '2022-05-25 20:33:00',462.0,4
    union all
    select '2022-05-25 21:26:00',574.0,77
    union all
    select '2022-05-25 21:59:00',436.0,30
    union all
    select '2022-05-25 23:32:00',100.0,72
    union all
    select '2022-05-25 23:42:00',272.0,95
    union all
    select '2022-05-26 00:11:00',604.0,25
    union all
    select '2022-05-26 01:11:00',436.0,16
    union all
    select '2022-05-26 02:25:00',804.0,22
    union all
    select '2022-05-26 02:52:00',756.0,65
    union all
    select '2022-05-26 03:09:00',274.0,8
    union all
    select '2022-05-26 04:17:00',136.0,86
    union all
    select '2022-05-26 05:17:00',598.0,88
    union all
    select '2022-05-26 05:26:00',460.0,88
    union all
    select '2022-05-26 06:07:00',348.0,40
    union all
    select '2022-05-26 06:20:00',736.0,28
    union all
    select '2022-05-26 07:16:00',750.0,33
    union all
    select '2022-05-26 07:34:00',996.0,29
    union all
    select '2022-05-26 07:41:00',848.0,51
    union all
    select '2022-05-26 07:41:00',782.0,13
    union all
    select '2022-05-26 07:55:00',746.0,13
    union all
    select '2022-05-26 07:55:00',284.0,94
    union all
    select '2022-05-26 08:31:00',292.0,86
    union all
    select '2022-05-26 08:37:00',754.0,84
    union all
    select '2022-05-26 08:59:00',240.0,40
    union all
    select '2022-05-26 09:07:00',670.0,82
    union all
    select '2022-05-26 09:09:00',872.0,12
    union all
    select '2022-05-26 09:19:00',996.0,26
    union all
    select '2022-05-26 10:38:00',126.0,17
    union all
    select '2022-05-26 12:33:00',356.0,13
    union all
    select '2022-05-26 12:49:00',158.0,69
    union all
    select '2022-05-26 13:54:00',600.0,90
    union all
    select '2022-05-26 14:41:00',128.0,1
    union all
    select '2022-05-26 15:16:00',352.0,82
    union all
    select '2022-05-26 16:06:00',804.0,72
    union all
    select '2022-05-26 16:34:00',950.0,18
    union all
    select '2022-05-26 17:21:00',288.0,75
    union all
    select '2022-05-26 19:11:00',972.0,33
    union all
    select '2022-05-27 01:24:00',310.0,85
    union all
    select '2022-05-27 02:27:00',380.0,15
    union all
    select '2022-05-27 02:55:00',192.0,59
    union all
    select '2022-05-27 03:13:00',262.0,21
    union all
    select '2022-05-27 04:40:00',618.0,66
    union all
    select '2022-05-27 05:07:00',722.0,69
    union all
    select '2022-05-27 05:20:00',198.0,94
    union all
    select '2022-05-27 05:58:00',688.0,8
    union all
    select '2022-05-27 06:05:00',160.0,78
    union all
    select '2022-05-27 08:12:00',436.0,43
    union all
    select '2022-05-27 09:06:00',558.0,18
    union all
    select '2022-05-27 11:26:00',844.0,41
    union all
    select '2022-05-27 13:03:00',736.0,88
    union all
    select '2022-05-27 13:05:00',182.0,10
    union all
    select '2022-05-27 13:09:00',508.0,24
    union all
    select '2022-05-27 14:56:00',762.0,32
    union all
    select '2022-05-27 15:19:00',502.0,17
    union all
    select '2022-05-27 15:23:00',874.0,44
    union all
    select '2022-05-27 15:24:00',354.0,77
    union all
    select '2022-05-27 16:25:00',928.0,63
    union all
    select '2022-05-27 16:45:00',586.0,9
    union all
    select '2022-05-27 17:34:00',372.0,52
    union all
    select '2022-05-27 19:16:00',576.0,27
    union all
    select '2022-05-27 19:41:00',430.0,52
    union all
    select '2022-05-27 22:31:00',780.0,42
    union all
    select '2022-05-27 22:32:00',868.0,66
    union all
    select '2022-05-27 22:40:00',742.0,84
    union all
    select '2022-05-27 22:52:00',978.0,78
    union all
    select '2022-05-27 22:58:00',600.0,54
    union all
    select '2022-05-27 23:35:00',178.0,32
    union all
    select '2022-05-28 00:43:00',720.0,83
    union all
    select '2022-05-28 00:57:00',574.0,5
    union all
    select '2022-05-28 01:17:00',758.0,21
    union all
    select '2022-05-28 01:29:00',614.0,70
    union all
    select '2022-05-28 03:17:00',336.0,48
    union all
    select '2022-05-28 03:20:00',918.0,88
    union all
    select '2022-05-28 03:32:00',464.0,85
    union all
    select '2022-05-28 04:21:00',792.0,65
    union all
    select '2022-05-28 06:22:00',380.0,99
    union all
    select '2022-05-28 07:41:00',600.0,68
    union all
    select '2022-05-28 07:44:00',552.0,14
    union all
    select '2022-05-28 08:07:00',556.0,43
    union all
    select '2022-05-28 08:48:00',208.0,99
    union all
    select '2022-05-28 09:51:00',258.0,97
    union all
    select '2022-05-28 12:14:00',506.0,66
    union all
    select '2022-05-28 13:16:00',738.0,75
    union all
    select '2022-05-28 14:02:00',382.0,3
    union all
    select '2022-05-28 15:53:00',406.0,52
    union all
    select '2022-05-28 16:37:00',314.0,25
    union all
    select '2022-05-28 19:31:00',568.0,20
    union all
    select '2022-05-28 21:33:00',634.0,85
    union all
    select '2022-05-28 22:35:00',502.0,26
    union all
    select '2022-05-28 23:25:00',988.0,11
    union all
    select '2022-05-28 23:33:00',294.0,27
    union all
    select '2022-05-29 00:44:00',262.0,67
    union all
    select '2022-05-29 00:56:00',474.0,17
    union all
    select '2022-05-29 03:59:00',954.0,65
    union all
    select '2022-05-29 06:57:00',768.0,25
    union all
    select '2022-05-29 07:37:00',238.0,14
    union all
    select '2022-05-29 07:41:00',260.0,73
    union all
    select '2022-05-29 09:04:00',368.0,86
    union all
    select '2022-05-29 09:28:00',348.0,93
    union all
    select '2022-05-29 09:46:00',814.0,56
    union all
    select '2022-05-29 10:10:00',512.0,9
    union all
    select '2022-05-29 10:43:00',224.0,97
    union all
    select '2022-05-29 11:46:00',534.0,6
    union all
    select '2022-05-29 12:02:00',300.0,74
    union all
    select '2022-05-29 14:08:00',204.0,64
    union all
    select '2022-05-29 14:36:00',716.0,39
    union all
    select '2022-05-29 15:16:00',302.0,79
    union all
    select '2022-05-29 15:35:00',474.0,6
    union all
    select '2022-05-29 16:01:00',530.0,42
    union all
    select '2022-05-29 16:36:00',382.0,51
    union all
    select '2022-05-29 16:57:00',270.0,99
    union all
    select '2022-05-29 17:36:00',190.0,69
    union all
    select '2022-05-29 17:52:00',276.0,89
    union all
    select '2022-05-29 18:10:00',342.0,92
    union all
    select '2022-05-29 18:38:00',256.0,49
    union all
    select '2022-05-29 19:06:00',882.0,43
    union all
    select '2022-05-29 21:29:00',518.0,56
    union all
    select '2022-05-29 21:38:00',974.0,3
    union all
    select '2022-05-29 21:39:00',232.0,73
    union all
    select '2022-05-30 01:33:00',400.0,87
    union all
    select '2022-05-30 02:52:00',222.0,45
    union all
    select '2022-05-30 07:18:00',634.0,35
    union all
    select '2022-05-30 11:15:00',544.0,47
    union all
    select '2022-05-30 13:21:00',506.0,96
    union all
    select '2022-05-30 16:43:00',336.0,7
    union all
    select '2022-05-30 16:53:00',634.0,68
    union all
    select '2022-05-30 17:47:00',954.0,3
    union all
    select '2022-05-30 20:32:00',316.0,7
    union all
    select '2022-05-30 20:34:00',236.0,4
    union all
    select '2022-05-30 20:37:00',138.0,68
    union all
    select '2022-05-31 01:39:00',412.0,52
    union all
    select '2022-05-31 03:20:00',698.0,98
    union all
    select '2022-05-31 03:21:00',120.0,56
    union all
    select '2022-05-31 08:08:00',118.0,77
    union all
    select '2022-05-31 09:44:00',184.0,3
    union all
    select '2022-05-31 10:41:00',186.0,86
    union all
    select '2022-05-31 10:58:00',274.0,8
    union all
    select '2022-05-31 12:46:00',392.0,61
    union all
    select '2022-05-31 13:37:00',576.0,84
    union all
    select '2022-05-31 13:50:00',604.0,97
    union all
    select '2022-05-31 14:03:00',660.0,47
    union all
    select '2022-05-31 14:30:00',238.0,1
    union all
    select '2022-05-31 14:48:00',818.0,46
    union all
    select '2022-05-31 15:14:00',208.0,37
    union all
    select '2022-05-31 15:41:00',364.0,33
    union all
    select '2022-05-31 15:53:00',370.0,20
    union all
    select '2022-05-31 17:07:00',326.0,3
    union all
    select '2022-05-31 17:16:00',158.0,64
    union all
    select '2022-05-31 18:12:00',862.0,94
    union all
    select '2022-05-31 18:39:00',382.0,55
    union all
    select '2022-05-31 18:40:00',134.0,37
    union all
    select '2022-05-31 19:11:00',254.0,58
    union all
    select '2022-05-31 21:40:00',168.0,7
    union all
    select '2022-06-01 00:02:00',832.0,64
    union all
    select '2022-06-01 00:44:00',430.0,9
    union all
    select '2022-06-01 01:53:00',780.0,88
    union all
    select '2022-06-01 02:29:00',540.0,86
    union all
    select '2022-06-01 04:34:00',996.0,35
    union all
    select '2022-06-01 05:21:00',368.0,45
    union all
    select '2022-06-01 05:26:00',340.0,2
    union all
    select '2022-06-01 10:12:00',140.0,19
    union all
    select '2022-06-01 10:15:00',906.0,47
    union all
    select '2022-06-01 10:20:00',736.0,32
    union all
    select '2022-06-01 10:32:00',432.0,43
    union all
    select '2022-06-01 10:56:00',226.0,8
    union all
    select '2022-06-01 11:28:00',202.0,49
    union all
    select '2022-06-01 11:29:00',674.0,78
    union all
    select '2022-06-01 14:25:00',760.0,73
    union all
    select '2022-06-01 14:26:00',412.0,59
    union all
    select '2022-06-01 14:29:00',376.0,10
    union all
    select '2022-06-01 15:23:00',680.0,74
    union all
    select '2022-06-01 16:02:00',180.0,78
    union all
    select '2022-06-01 16:14:00',410.0,41
    union all
    select '2022-06-01 20:05:00',140.0,18
    union all
    select '2022-06-01 20:17:00',502.0,58
    union all
    select '2022-06-02 00:24:00',208.0,90
    union all
    select '2022-06-02 02:05:00',886.0,1
    union all
    select '2022-06-02 02:19:00',328.0,33
    union all
    select '2022-06-02 02:21:00',480.0,42
    union all
    select '2022-06-02 04:55:00',240.0,56
    union all
    select '2022-06-02 05:36:00',744.0,56
    union all
    select '2022-06-02 06:18:00',356.0,86
    union all
    select '2022-06-02 06:30:00',352.0,83
    union all
    select '2022-06-02 07:44:00',426.0,40
    union all
    select '2022-06-02 08:39:00',608.0,33
    union all
    select '2022-06-02 09:34:00',490.0,91
    union all
    select '2022-06-02 09:51:00',160.0,47
    union all
    select '2022-06-02 10:45:00',620.0,53
    union all
    select '2022-06-02 12:40:00',344.0,2
    union all
    select '2022-06-02 13:20:00',646.0,66
    union all
    select '2022-06-02 15:54:00',400.0,11
    union all
    select '2022-06-02 17:22:00',860.0,1
    union all
    select '2022-06-02 18:16:00',548.0,98
    union all
    select '2022-06-02 18:49:00',670.0,93
    union all
    select '2022-06-02 19:08:00',612.0,46
    union all
    select '2022-06-02 19:49:00',692.0,24
    union all
    select '2022-06-02 22:29:00',340.0,76
    union all
    select '2022-06-03 00:35:00',720.0,45
    union all
    select '2022-06-03 02:34:00',510.0,56
    union all
    select '2022-06-03 02:39:00',330.0,11
    union all
    select '2022-06-03 02:48:00',166.0,56
    union all
    select '2022-06-03 04:35:00',792.0,96
    union all
    select '2022-06-03 04:37:00',358.0,24
    union all
    select '2022-06-03 04:52:00',336.0,68
    union all
    select '2022-06-03 06:14:00',272.0,25
    union all
    select '2022-06-03 06:22:00',434.0,79
    union all
    select '2022-06-03 07:26:00',644.0,44
    union all
    select '2022-06-03 08:03:00',816.0,96
    union all
    select '2022-06-03 08:15:00',622.0,71
    union all
    select '2022-06-03 09:15:00',802.0,72
    union all
    select '2022-06-03 11:30:00',614.0,33
    union all
    select '2022-06-03 11:46:00',116.0,5
    union all
    select '2022-06-03 11:54:00',484.0,66
    union all
    select '2022-06-03 12:36:00',800.0,29
    union all
    select '2022-06-03 13:01:00',250.0,22
    union all
    select '2022-06-03 13:09:00',612.0,9
    union all
    select '2022-06-03 13:54:00',498.0,25
    union all
    select '2022-06-03 14:40:00',156.0,77
    union all
    select '2022-06-03 15:08:00',396.0,2
    union all
    select '2022-06-03 15:32:00',444.0,13
    union all
    select '2022-06-03 17:07:00',174.0,27
    union all
    select '2022-06-03 17:23:00',828.0,31
    union all
    select '2022-06-03 17:28:00',988.0,33
    union all
    select '2022-06-03 18:26:00',608.0,85
    union all
    select '2022-06-03 20:23:00',224.0,32
    union all
    select '2022-06-03 21:48:00',710.0,97
    union all
    select '2022-06-03 21:49:00',384.0,20
    union all
    select '2022-06-03 22:41:00',770.0,32
    union all
    select '2022-06-04 01:30:00',978.0,7
    union all
    select '2022-06-04 02:02:00',790.0,71
    union all
    select '2022-06-04 02:11:00',400.0,98
    union all
    select '2022-06-04 03:11:00',534.0,10
    union all
    select '2022-06-04 03:46:00',156.0,40
    union all
    select '2022-06-04 03:54:00',696.0,96
    union all
    select '2022-06-04 05:34:00',232.0,44
    union all
    select '2022-06-04 05:51:00',584.0,56
    union all
    select '2022-06-04 06:22:00',732.0,56
    union all
    select '2022-06-04 06:40:00',852.0,6
    union all
    select '2022-06-04 07:48:00',934.0,71
    union all
    select '2022-06-04 07:48:00',326.0,12
    union all
    select '2022-06-04 09:17:00',996.0,6
    union all
    select '2022-06-04 09:56:00',704.0,17
    union all
    select '2022-06-04 10:32:00',566.0,61
    union all
    select '2022-06-04 11:12:00',192.0,39
    union all
    select '2022-06-04 12:23:00',188.0,39
    union all
    select '2022-06-04 13:51:00',116.0,36
    union all
    select '2022-06-04 14:15:00',102.0,26
    union all
    select '2022-06-04 14:54:00',678.0,89
    union all
    select '2022-06-04 15:30:00',962.0,33
    union all
    select '2022-06-04 17:06:00',586.0,44
    union all
    select '2022-06-04 17:33:00',822.0,33
    union all
    select '2022-06-04 18:26:00',758.0,80
    union all
    select '2022-06-04 20:40:00',740.0,39
    union all
    select '2022-06-04 21:03:00',564.0,27
    union all
    select '2022-06-04 21:17:00',352.0,44
    union all
    select '2022-06-04 21:49:00',142.0,66
    union all
    select '2022-06-04 23:57:00',480.0,99
    union all
    select '2022-06-05 04:41:00',936.0,81
    union all
    select '2022-06-05 04:44:00',790.0,2
    union all
    select '2022-06-05 05:36:00',480.0,14
    union all
    select '2022-06-05 06:39:00',570.0,62
    union all
    select '2022-06-05 06:56:00',254.0,26
    union all
    select '2022-06-05 07:37:00',838.0,40
    union all
    select '2022-06-05 07:43:00',734.0,78
    union all
    select '2022-06-05 08:44:00',148.0,20
    union all
    select '2022-06-05 08:54:00',280.0,22
    union all
    select '2022-06-05 09:11:00',302.0,94
    union all
    select '2022-06-05 11:54:00',390.0,89
    union all
    select '2022-06-05 12:29:00',692.0,16
    union all
    select '2022-06-05 13:07:00',460.0,12
    union all
    select '2022-06-05 14:53:00',852.0,67
    union all
    select '2022-06-05 16:35:00',622.0,54
    union all
    select '2022-06-05 17:38:00',108.0,71
    union all
    select '2022-06-05 17:55:00',290.0,90
    union all
    select '2022-06-05 18:57:00',918.0,38
    union all
    select '2022-06-05 19:24:00',660.0,51
    union all
    select '2022-06-05 20:21:00',420.0,44
    union all
    select '2022-06-05 20:44:00',892.0,4
    union all
    select '2022-06-05 21:27:00',862.0,10
    union all
    select '2022-06-05 22:29:00',698.0,96
    union all
    select '2022-06-05 23:01:00',198.0,10
    union all
    select '2022-06-05 23:05:00',316.0,26
    union all
    select '2022-06-06 00:58:00',602.0,85
    union all
    select '2022-06-06 02:15:00',578.0,48
    union all
    select '2022-06-06 05:05:00',630.0,58
    union all
    select '2022-06-06 07:10:00',648.0,62
    union all
    select '2022-06-06 10:45:00',500.0,25
    union all
    select '2022-06-06 10:45:00',700.0,24
    union all
    select '2022-06-06 12:08:00',290.0,54
    union all
    select '2022-06-06 12:22:00',446.0,91
    union all
    select '2022-06-06 12:43:00',692.0,92
    union all
    select '2022-06-06 13:47:00',614.0,99
    union all
    select '2022-06-06 13:55:00',984.0,39
    union all
    select '2022-06-06 14:56:00',910.0,74
    union all
    select '2022-06-06 18:21:00',432.0,19
    union all
    select '2022-06-06 21:38:00',488.0,22
    union all
    select '2022-06-06 22:35:00',730.0,69
    union all
    select '2022-06-07 00:39:00',672.0,62
    union all
    select '2022-06-07 02:12:00',880.0,62
    union all
    select '2022-06-07 02:59:00',372.0,77
    union all
    select '2022-06-07 03:04:00',478.0,40
    union all
    select '2022-06-07 04:13:00',940.0,47
    union all
    select '2022-06-07 04:57:00',372.0,83
    union all
    select '2022-06-07 05:51:00',826.0,38
    union all
    select '2022-06-07 06:15:00',962.0,13
    union all
    select '2022-06-07 06:57:00',494.0,48
    union all
    select '2022-06-07 07:48:00',842.0,29
    union all
    select '2022-06-07 10:03:00',894.0,98
    union all
    select '2022-06-07 10:06:00',510.0,10
    union all
    select '2022-06-07 10:18:00',756.0,78
    union all
    select '2022-06-07 11:33:00',422.0,7
    union all
    select '2022-06-07 12:00:00',542.0,62
    union all
    select '2022-06-07 15:28:00',590.0,36
    union all
    select '2022-06-07 21:12:00',122.0,60
    union all
    select '2022-06-07 23:13:00',824.0,46
    union all
    select '2022-06-07 23:14:00',810.0,81
    union all
    select '2022-06-08 00:08:00',524.0,41
    union all
    select '2022-06-08 02:56:00',716.0,77
    union all
    select '2022-06-08 03:28:00',552.0,89
    union all
    select '2022-06-08 03:28:00',800.0,43
    union all
    select '2022-06-08 03:35:00',676.0,94
    union all
    select '2022-06-08 03:43:00',524.0,32
    union all
    select '2022-06-08 10:58:00',370.0,73
    union all
    select '2022-06-08 11:37:00',854.0,63
    union all
    select '2022-06-08 12:27:00',262.0,44
    union all
    select '2022-06-08 13:42:00',118.0,65
    union all
    select '2022-06-08 14:17:00',840.0,41
    union all
    select '2022-06-08 16:05:00',656.0,70
    union all
    select '2022-06-08 16:35:00',808.0,86
    union all
    select '2022-06-08 17:36:00',558.0,87
    union all
    select '2022-06-08 20:00:00',264.0,98
    union all
    select '2022-06-08 20:31:00',180.0,24
    union all
    select '2022-06-08 22:28:00',200.0,94
    union all
    select '2022-06-08 22:44:00',886.0,72
    union all
    select '2022-06-08 23:31:00',366.0,21
    union all
    select '2022-06-09 01:38:00',380.0,71
    union all
    select '2022-06-09 02:20:00',236.0,9
    union all
    select '2022-06-09 05:19:00',988.0,13
    union all
    select '2022-06-09 05:20:00',158.0,90
    union all
    select '2022-06-09 06:17:00',526.0,65
    union all
    select '2022-06-09 06:38:00',510.0,22
    union all
    select '2022-06-09 06:47:00',980.0,98
    union all
    select '2022-06-09 06:55:00',386.0,98
    union all
    select '2022-06-09 08:06:00',208.0,69
    union all
    select '2022-06-09 08:34:00',574.0,93
    union all
    select '2022-06-09 08:55:00',916.0,51
    union all
    select '2022-06-09 09:15:00',470.0,93
    union all
    select '2022-06-09 11:48:00',424.0,97
    union all
    select '2022-06-09 12:24:00',468.0,79
    union all
    select '2022-06-09 12:27:00',616.0,98
    union all
    select '2022-06-09 13:06:00',818.0,17
    union all
    select '2022-06-09 14:10:00',526.0,85
    union all
    select '2022-06-09 14:49:00',624.0,98
    union all
    select '2022-06-09 15:34:00',876.0,64
    union all
    select '2022-06-09 19:00:00',980.0,34
    union all
    select '2022-06-09 20:16:00',634.0,80
    union all
    select '2022-06-09 21:25:00',318.0,59
    union all
    select '2022-06-09 21:45:00',566.0,76
    union all
    select '2022-06-09 22:00:00',568.0,50
    union all
    select '2022-06-09 22:46:00',618.0,14
    union all
    select '2022-06-10 00:56:00',386.0,80
    union all
    select '2022-06-10 01:57:00',258.0,64
    union all
    select '2022-06-10 02:01:00',724.0,81
    union all
    select '2022-06-10 02:31:00',750.0,55
    union all
    select '2022-06-10 02:32:00',928.0,54
    union all
    select '2022-06-10 03:34:00',112.0,19
    union all
    select '2022-06-10 04:02:00',696.0,79
    union all
    select '2022-06-10 04:23:00',430.0,11
    union all
    select '2022-06-10 05:48:00',244.0,81
    union all
    select '2022-06-10 06:40:00',104.0,37
    union all
    select '2022-06-10 07:19:00',714.0,14
    union all
    select '2022-06-10 08:13:00',632.0,65
    union all
    select '2022-06-10 08:43:00',786.0,82
    union all
    select '2022-06-10 09:55:00',722.0,3
    union all
    select '2022-06-10 10:46:00',354.0,56
    union all
    select '2022-06-10 12:04:00',148.0,30
    union all
    select '2022-06-10 15:19:00',636.0,71
    union all
    select '2022-06-10 15:55:00',316.0,94
    union all
    select '2022-06-10 17:30:00',538.0,72
    union all
    select '2022-06-10 17:40:00',278.0,56
    union all
    select '2022-06-10 17:49:00',260.0,87
    union all
    select '2022-06-10 18:35:00',344.0,14
    union all
    select '2022-06-10 20:18:00',450.0,80
    union all
    select '2022-06-10 20:40:00',692.0,10
    union all
    select '2022-06-10 21:52:00',480.0,58
    union all
    select '2022-06-10 22:05:00',218.0,77
    union all
    select '2022-06-11 00:37:00',158.0,78
    union all
    select '2022-06-11 00:51:00',910.0,2
    union all
    select '2022-06-11 01:23:00',934.0,57
    union all
    select '2022-06-11 02:15:00',310.0,92
    union all
    select '2022-06-11 02:46:00',288.0,33
    union all
    select '2022-06-11 03:18:00',298.0,16
    union all
    select '2022-06-11 04:43:00',636.0,14
    union all
    select '2022-06-11 05:56:00',552.0,77
    union all
    select '2022-06-11 07:07:00',618.0,5
    union all
    select '2022-06-11 08:25:00',810.0,6
    union all
    select '2022-06-11 10:02:00',770.0,25
    union all
    select '2022-06-11 10:39:00',752.0,28
    union all
    select '2022-06-11 13:03:00',780.0,5
    union all
    select '2022-06-11 13:18:00',200.0,38
    union all
    select '2022-06-11 20:33:00',266.0,45
    union all
    select '2022-06-11 22:36:00',720.0,77
    union all
    select '2022-06-11 23:16:00',452.0,50
    union all
    select '2022-06-11 23:16:00',164.0,50
    union all
    select '2022-06-12 01:52:00',782.0,5
    union all
    select '2022-06-12 02:06:00',378.0,77
    union all
    select '2022-06-12 04:58:00',198.0,88
    union all
    select '2022-06-12 06:13:00',490.0,26
    union all
    select '2022-06-12 10:42:00',266.0,79
    union all
    select '2022-06-12 11:06:00',740.0,23
    union all
    select '2022-06-12 11:57:00',160.0,46
    union all
    select '2022-06-12 13:27:00',478.0,58
    union all
    select '2022-06-12 13:32:00',492.0,29
    union all
    select '2022-06-12 13:59:00',742.0,63
    union all
    select '2022-06-12 17:28:00',256.0,96
    union all
    select '2022-06-12 18:45:00',964.0,30
    union all
    select '2022-06-12 19:58:00',436.0,7
    union all
    select '2022-06-12 21:14:00',964.0,24
    union all
    select '2022-06-13 00:17:00',876.0,84
    union all
    select '2022-06-13 02:00:00',568.0,64
    union all
    select '2022-06-13 03:27:00',882.0,63
    union all
    select '2022-06-13 03:48:00',848.0,53
    union all
    select '2022-06-13 04:35:00',656.0,4
    union all
    select '2022-06-13 05:02:00',402.0,63
    union all
    select '2022-06-13 05:08:00',396.0,89
    union all
    select '2022-06-13 05:27:00',598.0,81
    union all
    select '2022-06-13 08:20:00',850.0,91
    union all
    select '2022-06-13 09:04:00',164.0,68
    union all
    select '2022-06-13 09:26:00',908.0,91
    union all
    select '2022-06-13 10:47:00',696.0,95
    union all
    select '2022-06-13 11:04:00',854.0,61
    union all
    select '2022-06-13 12:50:00',650.0,47
    union all
    select '2022-06-13 12:51:00',266.0,43
    union all
    select '2022-06-13 14:13:00',136.0,8
    union all
    select '2022-06-13 14:15:00',734.0,18
    union all
    select '2022-06-13 14:24:00',996.0,15
    union all
    select '2022-06-13 14:56:00',644.0,25
    union all
    select '2022-06-13 15:09:00',598.0,46
    union all
    select '2022-06-13 15:10:00',332.0,74
    union all
    select '2022-06-13 18:08:00',736.0,58
    union all
    select '2022-06-13 21:25:00',956.0,86
    union all
    select '2022-06-13 22:43:00',310.0,33
    union all
    select '2022-06-14 00:00:00',112.0,36
    union all
    select '2022-06-14 00:08:00',750.0,46
    union all
    select '2022-06-14 00:24:00',854.0,2
    union all
    select '2022-06-14 01:57:00',184.0,82
    union all
    select '2022-06-14 03:15:00',692.0,68
    union all
    select '2022-06-14 03:19:00',586.0,70
    union all
    select '2022-06-14 04:52:00',822.0,16
    union all
    select '2022-06-14 05:17:00',886.0,37
    union all
    select '2022-06-14 05:22:00',760.0,74
    union all
    select '2022-06-14 05:33:00',108.0,71
    union all
    select '2022-06-14 06:08:00',416.0,26
    union all
    select '2022-06-14 06:33:00',502.0,66
    union all
    select '2022-06-14 07:39:00',918.0,32
    union all
    select '2022-06-14 07:46:00',518.0,17
    union all
    select '2022-06-14 08:15:00',388.0,20
    union all
    select '2022-06-14 08:47:00',700.0,30
    union all
    select '2022-06-14 10:27:00',442.0,50
    union all
    select '2022-06-14 12:11:00',508.0,2
    union all
    select '2022-06-14 13:36:00',908.0,4
    union all
    select '2022-06-14 15:03:00',110.0,32
    union all
    select '2022-06-14 15:13:00',408.0,18
    union all
    select '2022-06-14 16:29:00',698.0,61
    union all
    select '2022-06-14 16:56:00',316.0,91
    union all
    select '2022-06-14 17:00:00',546.0,28
    union all
    select '2022-06-14 18:16:00',114.0,87
    union all
    select '2022-06-14 19:04:00',950.0,40
    union all
    select '2022-06-14 21:08:00',512.0,55
    union all
    select '2022-06-14 22:10:00',770.0,23
    union all
    select '2022-06-14 22:17:00',498.0,89
    union all
    select '2022-06-14 23:42:00',928.0,97
    union all
    select '2022-06-15 00:38:00',932.0,28
    union all
    select '2022-06-15 05:19:00',424.0,63
    union all
    select '2022-06-15 06:31:00',422.0,11
    union all
    select '2022-06-15 07:05:00',156.0,69
    union all
    select '2022-06-15 07:58:00',514.0,41
    union all
    select '2022-06-15 09:51:00',364.0,51
    union all
    select '2022-06-15 11:05:00',906.0,90
    union all
    select '2022-06-15 13:26:00',822.0,45
    union all
    select '2022-06-15 13:39:00',224.0,61
    union all
    select '2022-06-15 18:01:00',154.0,29
    union all
    select '2022-06-15 18:07:00',286.0,12
    union all
    select '2022-06-15 18:11:00',278.0,8
    union all
    select '2022-06-15 18:26:00',974.0,63
    union all
    select '2022-06-15 18:55:00',826.0,38
    union all
    select '2022-06-15 19:57:00',244.0,93
    union all
    select '2022-06-15 20:51:00',448.0,81
    union all
    select '2022-06-16 01:33:00',480.0,79
    union all
    select '2022-06-16 04:55:00',544.0,88
    union all
    select '2022-06-16 04:58:00',970.0,72
    union all
    select '2022-06-16 05:02:00',828.0,53
    union all
    select '2022-06-16 05:13:00',404.0,80
    union all
    select '2022-06-16 05:30:00',714.0,2
    union all
    select '2022-06-16 05:39:00',278.0,48
    union all
    select '2022-06-16 06:15:00',622.0,28
    union all
    select '2022-06-16 06:32:00',678.0,69
    union all
    select '2022-06-16 06:40:00',464.0,9
    union all
    select '2022-06-16 08:18:00',220.0,42
    union all
    select '2022-06-16 08:52:00',872.0,9
    union all
    select '2022-06-16 10:27:00',104.0,13
    union all
    select '2022-06-16 10:29:00',814.0,12
    union all
    select '2022-06-16 10:30:00',372.0,22
    union all
    select '2022-06-16 11:02:00',976.0,23
    union all
    select '2022-06-16 11:45:00',246.0,24
    union all
    select '2022-06-16 15:17:00',364.0,15
    union all
    select '2022-06-16 15:26:00',954.0,65
    union all
    select '2022-06-16 17:02:00',914.0,25
    union all
    select '2022-06-16 17:30:00',104.0,28
    union all
    select '2022-06-16 19:28:00',480.0,15
    union all
    select '2022-06-16 19:42:00',994.0,34
    union all
    select '2022-06-16 19:45:00',588.0,7
    union all
    select '2022-06-16 21:33:00',900.0,10
    union all
    select '2022-06-16 21:40:00',536.0,56
    union all
    select '2022-06-16 22:17:00',298.0,53
    union all
    select '2022-06-16 23:04:00',912.0,12
    union all
    select '2022-06-16 23:35:00',388.0,69
    union all
    select '2022-06-17 00:24:00',424.0,96
    union all
    select '2022-06-17 00:49:00',862.0,87
    union all
    select '2022-06-17 00:50:00',370.0,27
    union all
    select '2022-06-17 01:26:00',262.0,52
    union all
    select '2022-06-17 02:12:00',470.0,84
    union all
    select '2022-06-17 02:40:00',430.0,33
    union all
    select '2022-06-17 02:50:00',262.0,8
    union all
    select '2022-06-17 04:57:00',616.0,91
    union all
    select '2022-06-17 05:47:00',596.0,14
    union all
    select '2022-06-17 06:18:00',628.0,79
    union all
    select '2022-06-17 07:02:00',548.0,90
    union all
    select '2022-06-17 07:08:00',392.0,87
    union all
    select '2022-06-17 07:52:00',472.0,29
    union all
    select '2022-06-17 10:11:00',128.0,28
    union all
    select '2022-06-17 10:53:00',674.0,43
    union all
    select '2022-06-17 11:11:00',434.0,92
    union all
    select '2022-06-17 11:45:00',980.0,66
    union all
    select '2022-06-17 12:46:00',498.0,85
    union all
    select '2022-06-17 13:01:00',254.0,99
    union all
    select '2022-06-17 13:05:00',248.0,6
    union all
    select '2022-06-17 14:10:00',348.0,4
    union all
    select '2022-06-17 14:20:00',996.0,57
    union all
    select '2022-06-17 16:03:00',946.0,10
    union all
    select '2022-06-17 16:43:00',910.0,58
    union all
    select '2022-06-17 17:38:00',538.0,90
    union all
    select '2022-06-17 20:12:00',128.0,85
    union all
    select '2022-06-17 21:43:00',296.0,21
    union all
    select '2022-06-17 21:46:00',122.0,81
    union all
    select '2022-06-17 23:18:00',682.0,56
    union all
    select '2022-06-17 23:19:00',604.0,17
    union all
    select '2022-06-18 00:22:00',450.0,2
    union all
    select '2022-06-18 03:26:00',882.0,58
    union all
    select '2022-06-18 07:01:00',732.0,40
    union all
    select '2022-06-18 07:21:00',682.0,22
    union all
    select '2022-06-18 07:32:00',810.0,12
    union all
    select '2022-06-18 09:51:00',186.0,24
    union all
    select '2022-06-18 09:58:00',706.0,25
    union all
    select '2022-06-18 10:02:00',676.0,15
    union all
    select '2022-06-18 11:38:00',182.0,42
    union all
    select '2022-06-18 11:51:00',476.0,2
    union all
    select '2022-06-18 11:52:00',608.0,14
    union all
    select '2022-06-18 12:03:00',812.0,69
    union all
    select '2022-06-18 13:13:00',256.0,97
    union all
    select '2022-06-18 14:13:00',136.0,32
    union all
    select '2022-06-18 14:23:00',148.0,20
    union all
    select '2022-06-18 14:32:00',994.0,67
    union all
    select '2022-06-18 15:34:00',774.0,82
    union all
    select '2022-06-18 16:36:00',816.0,23
    union all
    select '2022-06-18 16:39:00',808.0,65
    union all
    select '2022-06-18 20:14:00',850.0,38
    union all
    select '2022-06-18 21:53:00',558.0,43
    union all
    select '2022-06-18 21:58:00',782.0,90
    union all
    select '2022-06-18 22:42:00',856.0,23
    union all
    select '2022-06-18 22:52:00',222.0,1
    union all
    select '2022-06-18 22:56:00',848.0,11
    union all
    select '2022-06-18 23:51:00',452.0,59
    union all
    select '2022-06-19 00:28:00',720.0,82
    union all
    select '2022-06-19 00:45:00',298.0,8
    union all
    select '2022-06-19 01:01:00',774.0,35
    union all
    select '2022-06-19 01:27:00',754.0,4
    union all
    select '2022-06-19 02:35:00',970.0,41
    union all
    select '2022-06-19 03:02:00',170.0,24
    union all
    select '2022-06-19 04:26:00',300.0,47
    union all
    select '2022-06-19 04:40:00',926.0,86
    union all
    select '2022-06-19 04:41:00',968.0,42
    union all
    select '2022-06-19 07:25:00',268.0,89
    union all
    select '2022-06-19 07:31:00',446.0,31
    union all
    select '2022-06-19 09:23:00',686.0,44
    union all
    select '2022-06-19 13:52:00',706.0,73
    union all
    select '2022-06-19 15:38:00',642.0,63
    union all
    select '2022-06-19 16:42:00',964.0,68
    union all
    select '2022-06-19 17:35:00',774.0,67
    union all
    select '2022-06-19 17:45:00',266.0,26
    union all
    select '2022-06-19 17:46:00',300.0,7
    union all
    select '2022-06-19 19:19:00',330.0,43
    union all
    select '2022-06-19 19:20:00',956.0,8
    union all
    select '2022-06-19 21:59:00',984.0,56
    union all
    select '2022-06-19 22:57:00',792.0,76
    union all
    select '2022-06-19 23:04:00',270.0,40
    union all
    select '2022-06-19 23:57:00',316.0,90
    union all
    select '2022-06-20 00:10:00',212.0,81
    union all
    select '2022-06-20 00:13:00',996.0,80
    union all
    select '2022-06-20 01:43:00',340.0,8
    union all
    select '2022-06-20 02:30:00',824.0,58
    union all
    select '2022-06-20 03:19:00',530.0,27
    union all
    select '2022-06-20 03:24:00',364.0,72
    union all
    select '2022-06-20 03:29:00',764.0,94
    union all
    select '2022-06-20 03:36:00',238.0,25
    union all
    select '2022-06-20 04:58:00',216.0,66
    union all
    select '2022-06-20 06:13:00',234.0,20
    union all
    select '2022-06-20 10:06:00',996.0,36
    union all
    select '2022-06-20 11:05:00',894.0,79
    union all
    select '2022-06-20 12:30:00',788.0,22
    union all
    select '2022-06-20 12:56:00',676.0,1
    union all
    select '2022-06-20 13:13:00',576.0,12
    union all
    select '2022-06-20 13:36:00',236.0,67
    union all
    select '2022-06-20 14:16:00',174.0,78
    union all
    select '2022-06-20 15:43:00',290.0,88
    union all
    select '2022-06-20 18:50:00',676.0,45
    union all
    select '2022-06-20 19:05:00',122.0,60
    union all
    select '2022-06-20 19:09:00',600.0,17
    union all
    select '2022-06-20 19:31:00',392.0,55
    union all
    select '2022-06-20 19:45:00',616.0,79
    union all
    select '2022-06-20 19:53:00',564.0,71
    union all
    select '2022-06-20 20:33:00',324.0,85
    union all
    select '2022-06-20 20:48:00',132.0,60
    union all
    select '2022-06-20 21:00:00',578.0,24
    union all
    select '2022-06-20 21:33:00',200.0,47
    union all
    select '2022-06-20 22:16:00',428.0,95
    union all
    select '2022-06-21 00:51:00',910.0,32
    union all
    select '2022-06-21 03:31:00',774.0,79
    union all
    select '2022-06-21 03:55:00',476.0,43
    union all
    select '2022-06-21 04:53:00',668.0,72
    union all
    select '2022-06-21 04:59:00',690.0,95
    union all
    select '2022-06-21 05:20:00',108.0,59
    union all
    select '2022-06-21 07:27:00',286.0,91
    union all
    select '2022-06-21 09:38:00',696.0,82
    union all
    select '2022-06-21 10:17:00',980.0,16
    union all
    select '2022-06-21 13:21:00',448.0,90
    union all
    select '2022-06-21 13:53:00',682.0,31
    union all
    select '2022-06-21 17:52:00',198.0,90
    union all
    select '2022-06-21 18:06:00',866.0,98
    union all
    select '2022-06-21 19:11:00',386.0,17
    union all
    select '2022-06-21 19:28:00',388.0,30
    union all
    select '2022-06-21 21:07:00',554.0,3
    union all
    select '2022-06-21 21:43:00',550.0,71
    union all
    select '2022-06-21 22:02:00',800.0,60
    union all
    select '2022-06-21 22:03:00',622.0,89
    union all
    select '2022-06-21 22:25:00',678.0,84
    union all
    select '2022-06-21 23:07:00',724.0,32
    union all
    select '2022-06-21 23:27:00',978.0,83
    union all
    select '2022-06-22 00:27:00',384.0,46
    union all
    select '2022-06-22 02:16:00',906.0,80
    union all
    select '2022-06-22 04:05:00',316.0,75
    union all
    select '2022-06-22 08:37:00',836.0,36
    union all
    select '2022-06-22 09:19:00',252.0,88
    union all
    select '2022-06-22 10:21:00',852.0,50
    union all
    select '2022-06-22 11:51:00',590.0,27
    union all
    select '2022-06-22 12:31:00',952.0,5
    union all
    select '2022-06-22 12:33:00',680.0,52
    union all
    select '2022-06-22 12:40:00',836.0,78
    union all
    select '2022-06-22 13:44:00',850.0,9
    union all
    select '2022-06-22 17:08:00',964.0,15
    union all
    select '2022-06-22 17:15:00',214.0,52
    union all
    select '2022-06-22 18:41:00',864.0,14
    union all
    select '2022-06-22 20:30:00',250.0,8
    union all
    select '2022-06-22 22:12:00',704.0,15
    union all
    select '2022-06-22 22:48:00',818.0,91
    union all
    select '2022-06-22 23:20:00',850.0,41
    union all
    select '2022-06-23 00:43:00',634.0,6
    union all
    select '2022-06-23 02:22:00',310.0,77
    union all
    select '2022-06-23 02:30:00',212.0,11
    union all
    select '2022-06-23 05:20:00',256.0,15
    union all
    select '2022-06-23 07:55:00',992.0,50
    union all
    select '2022-06-23 08:42:00',248.0,86
    union all
    select '2022-06-23 10:36:00',682.0,3
    union all
    select '2022-06-23 12:00:00',218.0,54
    union all
    select '2022-06-23 12:59:00',368.0,8
    union all
    select '2022-06-23 13:52:00',574.0,39
    union all
    select '2022-06-23 14:27:00',490.0,8
    union all
    select '2022-06-23 16:39:00',282.0,83
    union all
    select '2022-06-23 17:25:00',732.0,90
    union all
    select '2022-06-23 18:56:00',552.0,61
    union all
    select '2022-06-23 19:24:00',410.0,53
    union all
    select '2022-06-23 20:51:00',706.0,43
    union all
    select '2022-06-23 23:17:00',706.0,76
    union all
    select '2022-06-24 02:44:00',498.0,56
    union all
    select '2022-06-24 06:45:00',870.0,77
    union all
    select '2022-06-24 07:06:00',366.0,96
    union all
    select '2022-06-24 07:14:00',960.0,33
    union all
    select '2022-06-24 07:37:00',592.0,67
    union all
    select '2022-06-24 09:21:00',806.0,28
    union all
    select '2022-06-24 10:26:00',974.0,15
    union all
    select '2022-06-24 10:28:00',532.0,62
    union all
    select '2022-06-24 10:42:00',718.0,52
    union all
    select '2022-06-24 12:21:00',898.0,19
    union all
    select '2022-06-24 12:33:00',592.0,87
    union all
    select '2022-06-24 12:58:00',476.0,71
    union all
    select '2022-06-24 13:33:00',774.0,10
    union all
    select '2022-06-24 15:16:00',988.0,12
    union all
    select '2022-06-24 15:48:00',700.0,58
    union all
    select '2022-06-24 18:20:00',210.0,34
    union all
    select '2022-06-24 18:33:00',298.0,65
    union all
    select '2022-06-24 20:53:00',468.0,85
    union all
    select '2022-06-24 21:51:00',548.0,99
    union all
    select '2022-06-25 02:48:00',136.0,31
    union all
    select '2022-06-25 03:27:00',290.0,36
    union all
    select '2022-06-25 04:24:00',690.0,33
    union all
    select '2022-06-25 04:34:00',992.0,10
    union all
    select '2022-06-25 06:47:00',708.0,1
    union all
    select '2022-06-25 10:32:00',666.0,40
    union all
    select '2022-06-25 10:58:00',288.0,95
    union all
    select '2022-06-25 11:57:00',932.0,94
    union all
    select '2022-06-25 12:19:00',472.0,92
    union all
    select '2022-06-25 13:14:00',958.0,17
    union all
    select '2022-06-25 14:03:00',502.0,64
    union all
    select '2022-06-25 14:47:00',844.0,78
    union all
    select '2022-06-25 16:15:00',886.0,10
    union all
    select '2022-06-25 16:47:00',288.0,68
    union all
    select '2022-06-25 18:02:00',136.0,78
    union all
    select '2022-06-25 20:32:00',390.0,24
    union all
    select '2022-06-25 20:55:00',140.0,86
    union all
    select '2022-06-25 21:35:00',762.0,77
    union all
    select '2022-06-25 23:19:00',416.0,37
    union all
    select '2022-06-25 23:41:00',404.0,97
    union all
    select '2022-06-26 01:55:00',712.0,58
    union all
    select '2022-06-26 02:40:00',350.0,87
    union all
    select '2022-06-26 02:54:00',894.0,40
    union all
    select '2022-06-26 03:09:00',522.0,21
    union all
    select '2022-06-26 03:18:00',614.0,68
    union all
    select '2022-06-26 03:57:00',154.0,98
    union all
    select '2022-06-26 04:39:00',714.0,4
    union all
    select '2022-06-26 05:10:00',472.0,14
    union all
    select '2022-06-26 07:37:00',328.0,4
    union all
    select '2022-06-26 07:55:00',900.0,7
    union all
    select '2022-06-26 08:25:00',856.0,26
    union all
    select '2022-06-26 10:07:00',518.0,15
    union all
    select '2022-06-26 11:18:00',854.0,81
    union all
    select '2022-06-26 11:30:00',268.0,83
    union all
    select '2022-06-26 11:44:00',438.0,98
    union all
    select '2022-06-26 12:51:00',872.0,40
    union all
    select '2022-06-26 12:52:00',196.0,99
    union all
    select '2022-06-26 14:19:00',398.0,93
    union all
    select '2022-06-26 14:49:00',930.0,45
    union all
    select '2022-06-26 15:24:00',294.0,5
    union all
    select '2022-06-26 16:44:00',448.0,85
    union all
    select '2022-06-26 19:10:00',406.0,15
    union all
    select '2022-06-26 20:48:00',704.0,54
    union all
    select '2022-06-26 21:17:00',976.0,1
    union all
    select '2022-06-26 22:13:00',928.0,37
    union all
    select '2022-06-26 23:02:00',526.0,36
    union all
    select '2022-06-26 23:32:00',586.0,54
    union all
    select '2022-06-27 02:40:00',250.0,75
    union all
    select '2022-06-27 03:01:00',846.0,60
    union all
    select '2022-06-27 03:59:00',858.0,83
    union all
    select '2022-06-27 04:12:00',242.0,26
    union all
    select '2022-06-27 04:45:00',736.0,53
    union all
    select '2022-06-27 05:39:00',508.0,69
    union all
    select '2022-06-27 08:32:00',974.0,63
    union all
    select '2022-06-27 08:57:00',874.0,61
    union all
    select '2022-06-27 09:08:00',670.0,77
    union all
    select '2022-06-27 11:46:00',746.0,55
    union all
    select '2022-06-27 12:48:00',472.0,33
    union all
    select '2022-06-27 13:04:00',992.0,86
    union all
    select '2022-06-27 13:33:00',594.0,36
    union all
    select '2022-06-27 14:15:00',536.0,36
    union all
    select '2022-06-27 14:19:00',606.0,15
    union all
    select '2022-06-27 15:02:00',872.0,52
    union all
    select '2022-06-27 15:32:00',320.0,71
    union all
    select '2022-06-27 15:58:00',518.0,48
    union all
    select '2022-06-27 17:45:00',752.0,67
    union all
    select '2022-06-27 18:28:00',790.0,85
    union all
    select '2022-06-27 21:31:00',204.0,25
    union all
    select '2022-06-27 22:19:00',662.0,97
    union all
    select '2022-06-27 23:11:00',796.0,66
    union all
    select '2022-06-27 23:28:00',970.0,11
    union all
    select '2022-06-27 23:55:00',148.0,27
    union all
    select '2022-06-28 03:19:00',886.0,31
    union all
    select '2022-06-28 03:26:00',342.0,97
    union all
    select '2022-06-28 05:20:00',854.0,60
    union all
    select '2022-06-28 08:18:00',256.0,34
    union all
    select '2022-06-28 08:39:00',768.0,47
    union all
    select '2022-06-28 09:12:00',298.0,13
    union all
    select '2022-06-28 09:36:00',688.0,1
    union all
    select '2022-06-28 09:40:00',624.0,83
    union all
    select '2022-06-28 10:01:00',102.0,76
    union all
    select '2022-06-28 10:25:00',544.0,88
    union all
    select '2022-06-28 13:42:00',732.0,84
    union all
    select '2022-06-28 13:42:00',824.0,4
    union all
    select '2022-06-28 15:59:00',398.0,45
    union all
    select '2022-06-28 18:40:00',486.0,20
    union all
    select '2022-06-28 19:50:00',514.0,80
    union all
    select '2022-06-28 20:26:00',368.0,56
    union all
    select '2022-06-28 21:08:00',704.0,49
    union all
    select '2022-06-28 21:21:00',616.0,82
    union all
    select '2022-06-28 23:32:00',708.0,4
    union all
    select '2022-06-29 00:39:00',160.0,88
    union all
    select '2022-06-29 02:58:00',872.0,75
    union all
    select '2022-06-29 03:00:00',612.0,44
    union all
    select '2022-06-29 04:41:00',548.0,89
    union all
    select '2022-06-29 07:51:00',512.0,1
    union all
    select '2022-06-29 10:22:00',786.0,84
    union all
    select '2022-06-29 12:24:00',634.0,72
    union all
    select '2022-06-29 15:07:00',102.0,23
    union all
    select '2022-06-29 15:24:00',560.0,69
    union all
    select '2022-06-29 16:50:00',270.0,30
    union all
    select '2022-06-29 18:23:00',776.0,70
    union all
    select '2022-06-29 20:12:00',218.0,18
    union all
    select '2022-06-29 20:34:00',386.0,29
    union all
    select '2022-06-29 22:40:00',272.0,44
    union all
    select '2022-06-29 22:50:00',974.0,91
    union all
    select '2022-06-29 23:50:00',184.0,69
    union all
    select '2022-06-30 00:01:00',632.0,63
    union all
    select '2022-06-30 01:28:00',210.0,2
    union all
    select '2022-06-30 01:33:00',836.0,97
    union all
    select '2022-06-30 01:41:00',896.0,62
    union all
    select '2022-06-30 03:05:00',326.0,12
    union all
    select '2022-06-30 03:07:00',894.0,45
    union all
    select '2022-06-30 04:06:00',814.0,5
    union all
    select '2022-06-30 05:08:00',532.0,80
    union all
    select '2022-06-30 05:31:00',774.0,84
    union all
    select '2022-06-30 09:42:00',350.0,31
    union all
    select '2022-06-30 10:29:00',494.0,75
    union all
    select '2022-06-30 11:12:00',492.0,94
    union all
    select '2022-06-30 14:29:00',814.0,26
    union all
    select '2022-06-30 15:34:00',348.0,34
    union all
    select '2022-06-30 15:54:00',162.0,72
    union all
    select '2022-06-30 15:58:00',416.0,63
    union all
    select '2022-06-30 16:00:00',510.0,80
    union all
    select '2022-06-30 16:57:00',436.0,23
    union all
    select '2022-06-30 18:40:00',856.0,18
    union all
    select '2022-06-30 20:51:00',914.0,8
    union all
    select '2022-07-01 00:29:00',408.0,20
    union all
    select '2022-07-01 01:25:00',550.0,20
    union all
    select '2022-07-01 02:28:00',304.0,40
    union all
    select '2022-07-01 03:13:00',518.0,43
    union all
    select '2022-07-01 04:38:00',598.0,26
    union all
    select '2022-07-01 04:47:00',126.0,68
    union all
    select '2022-07-01 04:52:00',414.0,93
    union all
    select '2022-07-01 05:11:00',714.0,51
    union all
    select '2022-07-01 05:34:00',468.0,37
    union all
    select '2022-07-01 05:55:00',472.0,21
    union all
    select '2022-07-01 07:14:00',224.0,71
    union all
    select '2022-07-01 09:04:00',230.0,62
    union all
    select '2022-07-01 09:46:00',274.0,24
    union all
    select '2022-07-01 10:09:00',528.0,56
    union all
    select '2022-07-01 10:18:00',144.0,9
    union all
    select '2022-07-01 10:45:00',422.0,68
    union all
    select '2022-07-01 11:55:00',698.0,42
    union all
    select '2022-07-01 12:32:00',346.0,43
    union all
    select '2022-07-01 14:51:00',124.0,70
    union all
    select '2022-07-01 15:24:00',244.0,17
    union all
    select '2022-07-01 17:20:00',114.0,28
    union all
    select '2022-07-01 18:44:00',468.0,59
    union all
    select '2022-07-01 20:32:00',726.0,93
    union all
    select '2022-07-01 22:59:00',724.0,85
    union all
    select '2022-07-01 23:10:00',438.0,66
    union all
    select '2022-07-01 23:32:00',484.0,69
    union all
    select '2022-07-02 03:09:00',934.0,92
    union all
    select '2022-07-02 04:30:00',374.0,24
    union all
    select '2022-07-02 06:01:00',792.0,70
    union all
    select '2022-07-02 06:27:00',648.0,36
    union all
    select '2022-07-02 06:50:00',320.0,80
    union all
    select '2022-07-02 07:00:00',166.0,96
    union all
    select '2022-07-02 08:08:00',146.0,50
    union all
    select '2022-07-02 08:24:00',476.0,42
    union all
    select '2022-07-02 08:28:00',502.0,37
    union all
    select '2022-07-02 10:54:00',434.0,71
    union all
    select '2022-07-02 12:44:00',654.0,44
    union all
    select '2022-07-02 13:24:00',580.0,95
    union all
    select '2022-07-02 13:37:00',600.0,96
    union all
    select '2022-07-02 15:10:00',592.0,18
    union all
    select '2022-07-02 16:19:00',550.0,38
    union all
    select '2022-07-02 20:53:00',560.0,68
    union all
    select '2022-07-02 21:20:00',584.0,86
    union all
    select '2022-07-02 21:34:00',976.0,10
    union all
    select '2022-07-03 00:03:00',364.0,59
    union all
    select '2022-07-03 00:05:00',724.0,82
    union all
    select '2022-07-03 02:26:00',834.0,78
    union all
    select '2022-07-03 03:49:00',694.0,68
    union all
    select '2022-07-03 06:12:00',550.0,74
    union all
    select '2022-07-03 06:43:00',106.0,21
    union all
    select '2022-07-03 08:16:00',898.0,85
    union all
    select '2022-07-03 08:19:00',206.0,48
    union all
    select '2022-07-03 10:04:00',992.0,42
    union all
    select '2022-07-03 11:10:00',152.0,13
    union all
    select '2022-07-03 13:29:00',260.0,10
    union all
    select '2022-07-03 14:48:00',548.0,56
    union all
    select '2022-07-03 14:51:00',290.0,42
    union all
    select '2022-07-03 14:59:00',200.0,86
    union all
    select '2022-07-03 15:04:00',772.0,72
    union all
    select '2022-07-03 16:27:00',942.0,83
    union all
    select '2022-07-03 20:32:00',198.0,35
    union all
    select '2022-07-03 22:54:00',982.0,45
    union all
    select '2022-07-04 00:41:00',676.0,79
    union all
    select '2022-07-04 02:26:00',352.0,53
    union all
    select '2022-07-04 02:49:00',718.0,9
    union all
    select '2022-07-04 04:09:00',916.0,60
    union all
    select '2022-07-04 04:28:00',194.0,61
    union all
    select '2022-07-04 05:30:00',650.0,91
    union all
    select '2022-07-04 06:55:00',906.0,68
    union all
    select '2022-07-04 07:09:00',188.0,19
    union all
    select '2022-07-04 07:39:00',226.0,63
    union all
    select '2022-07-04 08:50:00',990.0,30
    union all
    select '2022-07-04 09:57:00',948.0,25
    union all
    select '2022-07-04 10:01:00',844.0,53
    union all
    select '2022-07-04 11:53:00',422.0,81
    union all
    select '2022-07-04 12:48:00',352.0,44
    union all
    select '2022-07-04 13:23:00',704.0,47
    union all
    select '2022-07-04 13:56:00',250.0,11
    union all
    select '2022-07-04 17:53:00',592.0,69
    union all
    select '2022-07-04 19:25:00',374.0,49
    union all
    select '2022-07-04 20:25:00',734.0,92
    union all
    select '2022-07-04 21:00:00',200.0,54
    union all
    select '2022-07-04 21:01:00',894.0,49
    union all
    select '2022-07-04 22:58:00',470.0,30
    union all
    select '2022-07-05 01:01:00',160.0,85
    union all
    select '2022-07-05 01:29:00',532.0,96
    union all
    select '2022-07-05 02:42:00',330.0,68
    union all
    select '2022-07-05 05:06:00',956.0,65
    union all
    select '2022-07-05 06:49:00',512.0,5
    union all
    select '2022-07-05 08:58:00',940.0,46
    union all
    select '2022-07-05 09:49:00',876.0,70
    union all
    select '2022-07-05 11:03:00',178.0,64
    union all
    select '2022-07-05 11:32:00',722.0,83
    union all
    select '2022-07-05 12:58:00',860.0,48
    union all
    select '2022-07-05 16:31:00',904.0,54
    union all
    select '2022-07-05 17:02:00',720.0,95
    union all
    select '2022-07-05 17:26:00',812.0,84
    union all
    select '2022-07-05 18:20:00',874.0,45
    union all
    select '2022-07-05 20:59:00',204.0,78
    union all
    select '2022-07-05 22:24:00',562.0,52
    union all
    select '2022-07-05 22:57:00',124.0,54
    union all
    select '2022-07-06 00:06:00',310.0,71
    union all
    select '2022-07-06 01:51:00',860.0,99
    union all
    select '2022-07-06 02:16:00',706.0,46
    union all
    select '2022-07-06 03:35:00',482.0,44
    union all
    select '2022-07-06 05:01:00',590.0,75
    union all
    select '2022-07-06 05:18:00',810.0,36
    union all
    select '2022-07-06 05:39:00',528.0,78
    union all
    select '2022-07-06 09:52:00',494.0,65
    union all
    select '2022-07-06 10:53:00',348.0,98
    union all
    select '2022-07-06 11:01:00',460.0,65
    union all
    select '2022-07-06 11:03:00',526.0,90
    union all
    select '2022-07-06 11:58:00',592.0,18
    union all
    select '2022-07-06 11:58:00',272.0,93
    union all
    select '2022-07-06 13:09:00',422.0,6
    union all
    select '2022-07-06 13:11:00',308.0,10
    union all
    select '2022-07-06 13:12:00',970.0,17
    union all
    select '2022-07-06 13:35:00',808.0,12
    union all
    select '2022-07-06 13:55:00',454.0,65
    union all
    select '2022-07-06 14:08:00',200.0,20
    union all
    select '2022-07-06 18:45:00',746.0,74
    union all
    select '2022-07-06 19:08:00',476.0,79
    union all
    select '2022-07-06 19:46:00',552.0,66
    union all
    select '2022-07-06 22:02:00',612.0,51
    union all
    select '2022-07-06 22:02:00',672.0,81
    union all
    select '2022-07-06 23:35:00',160.0,78
    union all
    select '2022-07-07 00:13:00',300.0,70
    union all
    select '2022-07-07 01:27:00',372.0,86
    union all
    select '2022-07-07 01:52:00',372.0,97
    union all
    select '2022-07-07 04:44:00',234.0,35
    union all
    select '2022-07-07 05:55:00',424.0,96
    union all
    select '2022-07-07 06:17:00',348.0,29
    union all
    select '2022-07-07 06:58:00',180.0,95
    union all
    select '2022-07-07 08:02:00',506.0,20
    union all
    select '2022-07-07 09:29:00',362.0,6
    union all
    select '2022-07-07 12:36:00',644.0,30
    union all
    select '2022-07-07 13:09:00',916.0,23
    union all
    select '2022-07-07 13:18:00',366.0,25
    union all
    select '2022-07-07 13:59:00',254.0,83
    union all
    select '2022-07-07 14:14:00',372.0,5
    union all
    select '2022-07-07 14:37:00',356.0,32
    union all
    select '2022-07-07 15:04:00',682.0,6
    union all
    select '2022-07-07 15:45:00',138.0,23
    union all
    select '2022-07-07 17:29:00',530.0,1
    union all
    select '2022-07-07 18:11:00',544.0,65
    union all
    select '2022-07-07 18:14:00',756.0,33
    union all
    select '2022-07-07 18:22:00',742.0,68
    union all
    select '2022-07-07 20:12:00',242.0,64
    union all
    select '2022-07-07 20:52:00',718.0,25
    union all
    select '2022-07-07 21:43:00',158.0,42
    union all
    select '2022-07-07 21:55:00',884.0,37
    union all
    select '2022-07-07 22:02:00',344.0,37
    union all
    select '2022-07-07 22:06:00',482.0,65
    union all
    select '2022-07-08 01:55:00',450.0,46
    union all
    select '2022-07-08 03:07:00',524.0,37
    union all
    select '2022-07-08 06:47:00',342.0,65
    union all
    select '2022-07-08 07:44:00',716.0,18
    union all
    select '2022-07-08 07:49:00',186.0,80
    union all
    select '2022-07-08 08:40:00',302.0,72
    union all
    select '2022-07-08 09:00:00',524.0,26
    union all
    select '2022-07-08 10:15:00',236.0,58
    union all
    select '2022-07-08 12:23:00',852.0,39
    union all
    select '2022-07-08 13:01:00',864.0,10
    union all
    select '2022-07-08 15:52:00',602.0,63
    union all
    select '2022-07-08 16:08:00',438.0,68
    union all
    select '2022-07-08 18:04:00',730.0,27
    union all
    select '2022-07-08 21:16:00',894.0,73
    union all
    select '2022-07-08 21:23:00',460.0,97
    union all
    select '2022-07-08 21:41:00',790.0,81
    union all
    select '2022-07-08 21:47:00',130.0,37
    union all
    select '2022-07-08 22:01:00',438.0,55
    union all
    select '2022-07-09 00:45:00',648.0,65
    union all
    select '2022-07-09 02:15:00',274.0,33
    union all
    select '2022-07-09 02:47:00',736.0,8
    union all
    select '2022-07-09 02:55:00',508.0,64
    union all
    select '2022-07-09 03:48:00',920.0,70
    union all
    select '2022-07-09 03:51:00',510.0,55
    union all
    select '2022-07-09 04:16:00',840.0,20
    union all
    select '2022-07-09 04:30:00',640.0,46
    union all
    select '2022-07-09 07:50:00',816.0,92
    union all
    select '2022-07-09 08:49:00',258.0,87
    union all
    select '2022-07-09 09:04:00',386.0,77
    union all
    select '2022-07-09 09:46:00',684.0,33
    union all
    select '2022-07-09 09:53:00',308.0,16
    union all
    select '2022-07-09 12:19:00',208.0,23
    union all
    select '2022-07-09 14:04:00',460.0,78
    union all
    select '2022-07-09 15:13:00',896.0,92
    union all
    select '2022-07-09 16:05:00',398.0,54
    union all
    select '2022-07-09 16:51:00',204.0,93
    union all
    select '2022-07-09 18:45:00',298.0,71
    union all
    select '2022-07-09 19:51:00',670.0,53
    union all
    select '2022-07-09 20:11:00',268.0,82
    union all
    select '2022-07-09 21:29:00',406.0,48
    union all
    select '2022-07-09 22:22:00',220.0,83
    union all
    select '2022-07-09 22:40:00',834.0,56
    union all
    select '2022-07-09 22:47:00',484.0,23
    union all
    select '2022-07-09 23:07:00',916.0,62
    union all
    select '2022-07-09 23:51:00',456.0,20
    union all
    select '2022-07-10 00:00:00',286.0,82
    union all
    select '2022-07-10 00:28:00',680.0,78
    union all
    select '2022-07-10 00:29:00',206.0,13
    union all
    select '2022-07-10 01:13:00',124.0,96
    union all
    select '2022-07-10 01:14:00',266.0,86
    union all
    select '2022-07-10 02:19:00',374.0,92
    union all
    select '2022-07-10 04:06:00',662.0,70
    union all
    select '2022-07-10 04:11:00',304.0,91
    union all
    select '2022-07-10 04:46:00',984.0,3
    union all
    select '2022-07-10 06:26:00',410.0,2
    union all
    select '2022-07-10 08:03:00',998.0,68
    union all
    select '2022-07-10 09:26:00',136.0,99
    union all
    select '2022-07-10 09:35:00',296.0,48
    union all
    select '2022-07-10 12:20:00',896.0,31
    union all
    select '2022-07-10 13:16:00',858.0,95
    union all
    select '2022-07-10 13:48:00',732.0,45
    union all
    select '2022-07-10 14:14:00',200.0,22
    union all
    select '2022-07-10 15:09:00',320.0,73
    union all
    select '2022-07-10 16:24:00',672.0,12
    union all
    select '2022-07-10 16:50:00',826.0,77
    union all
    select '2022-07-10 17:35:00',804.0,44
    union all
    select '2022-07-10 17:44:00',800.0,95
    union all
    select '2022-07-10 17:57:00',464.0,49
    union all
    select '2022-07-10 20:04:00',490.0,57
    union all
    select '2022-07-10 20:20:00',852.0,8
    union all
    select '2022-07-10 21:26:00',982.0,78
    union all
    select '2022-07-10 22:36:00',144.0,45
    union all
    select '2022-07-10 22:45:00',248.0,72
    union all
    select '2022-07-10 23:23:00',492.0,87
    union all
    select '2022-07-10 23:58:00',512.0,61
    union all
    select '2022-07-11 02:23:00',998.0,78
    union all
    select '2022-07-11 02:26:00',394.0,39
    union all
    select '2022-07-11 02:56:00',638.0,80
    union all
    select '2022-07-11 04:14:00',990.0,56
    union all
    select '2022-07-11 04:38:00',746.0,65
    union all
    select '2022-07-11 06:13:00',776.0,70
    union all
    select '2022-07-11 06:55:00',652.0,95
    union all
    select '2022-07-11 06:56:00',440.0,63
    union all
    select '2022-07-11 08:17:00',918.0,18
    union all
    select '2022-07-11 08:37:00',812.0,69
    union all
    select '2022-07-11 10:33:00',336.0,98
    union all
    select '2022-07-11 11:02:00',900.0,32
    union all
    select '2022-07-11 11:43:00',354.0,64
    union all
    select '2022-07-11 12:57:00',224.0,26
    union all
    select '2022-07-11 13:07:00',956.0,72
    union all
    select '2022-07-11 14:05:00',962.0,12
    union all
    select '2022-07-11 14:08:00',966.0,85
    union all
    select '2022-07-11 14:21:00',784.0,80
    union all
    select '2022-07-11 14:47:00',420.0,71
    union all
    select '2022-07-11 15:59:00',752.0,28
    union all
    select '2022-07-11 16:38:00',228.0,40
    union all
    select '2022-07-11 18:08:00',216.0,59
    union all
    select '2022-07-11 19:18:00',352.0,12
    union all
    select '2022-07-11 19:57:00',560.0,98
    union all
    select '2022-07-11 20:15:00',938.0,26
    union all
    select '2022-07-11 22:01:00',156.0,68
    union all
    select '2022-07-11 22:45:00',660.0,34
    union all
    select '2022-07-11 23:41:00',870.0,38
    union all
    select '2022-07-12 01:36:00',136.0,1
    union all
    select '2022-07-12 03:35:00',672.0,66
    union all
    select '2022-07-12 05:17:00',416.0,63
    union all
    select '2022-07-12 08:26:00',412.0,94
    union all
    select '2022-07-12 08:56:00',398.0,69
    union all
    select '2022-07-12 10:25:00',588.0,64
    union all
    select '2022-07-12 11:05:00',584.0,83
    union all
    select '2022-07-12 11:08:00',892.0,17
    union all
    select '2022-07-12 11:56:00',966.0,19
    union all
    select '2022-07-12 15:09:00',660.0,48
    union all
    select '2022-07-12 15:56:00',376.0,31
    union all
    select '2022-07-12 16:29:00',110.0,66
    union all
    select '2022-07-12 16:34:00',658.0,53
    union all
    select '2022-07-12 16:36:00',160.0,35
    union all
    select '2022-07-12 16:56:00',640.0,75
    union all
    select '2022-07-12 18:58:00',836.0,70
    union all
    select '2022-07-12 19:00:00',842.0,39
    union all
    select '2022-07-12 20:22:00',888.0,47
    union all
    select '2022-07-12 21:57:00',516.0,13
    union all
    select '2022-07-12 22:13:00',958.0,30
    union all
    select '2022-07-12 22:13:00',786.0,92
    union all
    select '2022-07-13 01:28:00',568.0,10
    union all
    select '2022-07-13 01:38:00',334.0,70
    union all
    select '2022-07-13 03:06:00',994.0,32
    union all
    select '2022-07-13 05:09:00',544.0,84
    union all
    select '2022-07-13 05:10:00',748.0,40
    union all
    select '2022-07-13 05:47:00',866.0,75
    union all
    select '2022-07-13 08:34:00',672.0,36
    union all
    select '2022-07-13 10:04:00',404.0,77
    union all
    select '2022-07-13 11:03:00',674.0,2
    union all
    select '2022-07-13 11:09:00',788.0,73
    union all
    select '2022-07-13 11:44:00',870.0,72
    union all
    select '2022-07-13 11:47:00',296.0,72
    union all
    select '2022-07-13 11:51:00',964.0,64
    union all
    select '2022-07-13 13:20:00',340.0,17
    union all
    select '2022-07-13 13:24:00',878.0,1
    union all
    select '2022-07-13 14:31:00',264.0,3
    union all
    select '2022-07-13 14:53:00',472.0,50
    union all
    select '2022-07-13 14:55:00',806.0,66
    union all
    select '2022-07-13 16:25:00',580.0,55
    union all
    select '2022-07-13 19:39:00',958.0,64
    union all
    select '2022-07-13 19:59:00',482.0,57
    union all
    select '2022-07-13 20:45:00',408.0,7
    union all
    select '2022-07-13 22:14:00',188.0,40
    union all
    select '2022-07-13 22:44:00',434.0,32
    union all
    select '2022-07-13 23:21:00',444.0,97
    union all
    select '2022-07-13 23:24:00',946.0,85
    union all
    select '2022-07-14 01:22:00',308.0,58
    union all
    select '2022-07-14 01:55:00',382.0,75
    union all
    select '2022-07-14 02:32:00',124.0,97
    union all
    select '2022-07-14 03:32:00',644.0,27
    union all
    select '2022-07-14 03:47:00',554.0,53
    union all
    select '2022-07-14 04:33:00',804.0,49
    union all
    select '2022-07-14 05:36:00',502.0,73
    union all
    select '2022-07-14 05:39:00',742.0,60
    union all
    select '2022-07-14 06:18:00',332.0,95
    union all
    select '2022-07-14 06:30:00',782.0,85
    union all
    select '2022-07-14 06:55:00',670.0,23
    union all
    select '2022-07-14 08:27:00',800.0,84
    union all
    select '2022-07-14 08:58:00',746.0,2
    union all
    select '2022-07-14 09:40:00',756.0,11
    union all
    select '2022-07-14 09:51:00',736.0,80
    union all
    select '2022-07-14 11:03:00',696.0,62
    union all
    select '2022-07-14 14:21:00',258.0,21
    union all
    select '2022-07-14 16:07:00',394.0,55
    union all
    select '2022-07-14 16:09:00',692.0,95
    union all
    select '2022-07-14 16:50:00',560.0,86
    union all
    select '2022-07-14 17:46:00',224.0,65
    union all
    select '2022-07-14 18:51:00',560.0,17
    union all
    select '2022-07-14 19:56:00',282.0,88
    union all
    select '2022-07-14 21:02:00',792.0,95
    union all
    select '2022-07-14 21:15:00',546.0,1
    union all
    select '2022-07-15 01:43:00',488.0,87
    union all
    select '2022-07-15 02:53:00',316.0,59
    union all
    select '2022-07-15 03:05:00',100.0,18
    union all
    select '2022-07-15 03:11:00',140.0,81
    union all
    select '2022-07-15 05:01:00',174.0,4
    union all
    select '2022-07-15 14:59:00',282.0,4
    union all
    select '2022-07-15 20:51:00',960.0,84
    union all
    select '2022-07-15 22:49:00',122.0,71
    union all
    select '2022-07-15 23:01:00',538.0,6
    union all
    select '2022-07-15 23:24:00',374.0,25
    union all
    select '2022-07-15 23:48:00',772.0,97
    union all
    select '2022-07-16 00:28:00',988.0,24
    union all
    select '2022-07-16 00:28:00',654.0,65
    union all
    select '2022-07-16 01:46:00',558.0,15
    union all
    select '2022-07-16 05:18:00',330.0,31
    union all
    select '2022-07-16 06:11:00',852.0,47
    union all
    select '2022-07-16 08:15:00',842.0,1
    union all
    select '2022-07-16 08:59:00',830.0,49
    union all
    select '2022-07-16 09:08:00',580.0,19
    union all
    select '2022-07-16 09:16:00',878.0,81
    union all
    select '2022-07-16 09:52:00',946.0,55
    union all
    select '2022-07-16 13:02:00',280.0,92
    union all
    select '2022-07-16 14:38:00',152.0,48
    union all
    select '2022-07-16 15:38:00',212.0,30
    union all
    select '2022-07-16 17:15:00',890.0,51
    union all
    select '2022-07-16 20:40:00',946.0,27
    union all
    select '2022-07-16 20:53:00',872.0,5
    union all
    select '2022-07-16 21:46:00',688.0,12
    union all
    select '2022-07-16 21:52:00',390.0,64
    union all
    select '2022-07-16 22:41:00',870.0,56
    union all
    select '2022-07-16 23:15:00',634.0,44
    union all
    select '2022-07-16 23:29:00',202.0,19
    union all
    select '2022-07-17 01:02:00',746.0,10
    union all
    select '2022-07-17 02:24:00',502.0,60
    union all
    select '2022-07-17 03:21:00',516.0,25
    union all
    select '2022-07-17 03:39:00',620.0,74
    union all
    select '2022-07-17 04:19:00',340.0,67
    union all
    select '2022-07-17 04:27:00',224.0,6
    union all
    select '2022-07-17 05:54:00',300.0,39
    union all
    select '2022-07-17 06:17:00',230.0,26
    union all
    select '2022-07-17 07:26:00',842.0,43
    union all
    select '2022-07-17 08:59:00',810.0,68
    union all
    select '2022-07-17 09:30:00',534.0,63
    union all
    select '2022-07-17 09:50:00',270.0,65
    union all
    select '2022-07-17 09:58:00',246.0,97
    union all
    select '2022-07-17 11:54:00',666.0,86
    union all
    select '2022-07-17 13:47:00',500.0,91
    union all
    select '2022-07-17 14:39:00',236.0,10
    union all
    select '2022-07-17 14:48:00',286.0,76
    union all
    select '2022-07-17 14:59:00',542.0,34
    union all
    select '2022-07-17 14:59:00',116.0,53
    union all
    select '2022-07-17 15:13:00',560.0,27
    union all
    select '2022-07-17 18:27:00',416.0,80
    union all
    select '2022-07-17 19:13:00',836.0,41
    union all
    select '2022-07-17 20:53:00',334.0,84
    union all
    select '2022-07-17 21:09:00',312.0,33
    union all
    select '2022-07-17 22:01:00',844.0,46
    union all
    select '2022-07-17 22:43:00',284.0,13
    union all
    select '2022-07-18 00:42:00',690.0,64
    union all
    select '2022-07-18 03:34:00',886.0,8
    union all
    select '2022-07-18 04:09:00',316.0,1
    union all
    select '2022-07-18 04:14:00',312.0,29
    union all
    select '2022-07-18 11:09:00',152.0,96
    union all
    select '2022-07-18 11:29:00',880.0,82
    union all
    select '2022-07-18 12:21:00',172.0,23
    union all
    select '2022-07-18 12:34:00',424.0,13
    union all
    select '2022-07-18 12:58:00',112.0,60
    union all
    select '2022-07-18 15:48:00',816.0,60
    union all
    select '2022-07-18 16:23:00',838.0,20
    union all
    select '2022-07-18 17:16:00',366.0,48
    union all
    select '2022-07-18 17:17:00',866.0,16
    union all
    select '2022-07-18 19:10:00',776.0,20
    union all
    select '2022-07-18 19:32:00',122.0,88
    union all
    select '2022-07-18 19:54:00',758.0,67
    union all
    select '2022-07-18 19:55:00',170.0,21
    union all
    select '2022-07-18 21:05:00',126.0,61
    union all
    select '2022-07-18 22:45:00',534.0,80
    union all
    select '2022-07-18 22:56:00',616.0,82
    union all
    select '2022-07-19 01:27:00',970.0,31
    union all
    select '2022-07-19 04:43:00',832.0,99
    union all
    select '2022-07-19 04:52:00',244.0,1
    union all
    select '2022-07-19 05:45:00',160.0,96
    union all
    select '2022-07-19 06:16:00',132.0,82
    union all
    select '2022-07-19 06:37:00',284.0,26
    union all
    select '2022-07-19 07:17:00',548.0,56
    union all
    select '2022-07-19 07:45:00',942.0,18
    union all
    select '2022-07-19 09:23:00',378.0,12
    union all
    select '2022-07-19 09:53:00',698.0,36
    union all
    select '2022-07-19 10:49:00',912.0,99
    union all
    select '2022-07-19 13:38:00',448.0,18
    union all
    select '2022-07-19 14:05:00',452.0,66
    union all
    select '2022-07-19 14:14:00',352.0,6
    union all
    select '2022-07-19 14:16:00',470.0,52
    union all
    select '2022-07-19 15:45:00',906.0,90
    union all
    select '2022-07-19 19:28:00',964.0,59
    union all
    select '2022-07-19 20:18:00',714.0,23
    union all
    select '2022-07-19 20:33:00',792.0,90
    union all
    select '2022-07-19 22:24:00',564.0,92
    union all
    select '2022-07-19 22:51:00',654.0,82
    union all
    select '2022-07-20 01:34:00',708.0,64
    union all
    select '2022-07-20 01:59:00',112.0,4
    union all
    select '2022-07-20 02:55:00',350.0,2
    union all
    select '2022-07-20 04:30:00',258.0,65
    union all
    select '2022-07-20 05:40:00',960.0,83
    union all
    select '2022-07-20 07:18:00',670.0,6
    union all
    select '2022-07-20 09:53:00',220.0,35
    union all
    select '2022-07-20 10:58:00',368.0,40
    union all
    select '2022-07-20 11:03:00',518.0,38
    union all
    select '2022-07-20 13:01:00',268.0,45
    union all
    select '2022-07-20 13:31:00',784.0,54
    union all
    select '2022-07-20 13:33:00',818.0,24
    union all
    select '2022-07-20 14:58:00',570.0,80
    union all
    select '2022-07-20 15:13:00',316.0,31
    union all
    select '2022-07-20 17:42:00',962.0,37
    union all
    select '2022-07-20 21:08:00',660.0,11
    union all
    select '2022-07-20 21:17:00',662.0,74
    union all
    select '2022-07-20 22:18:00',984.0,15
    union all
    select '2022-07-20 22:22:00',880.0,64
    union all
    select '2022-07-20 23:18:00',174.0,17
    union all
    select '2022-07-21 01:00:00',620.0,30
    union all
    select '2022-07-21 01:07:00',816.0,33
    union all
    select '2022-07-21 02:00:00',138.0,57
    union all
    select '2022-07-21 03:15:00',500.0,24
    union all
    select '2022-07-21 05:49:00',188.0,16
    union all
    select '2022-07-21 05:58:00',220.0,55
    union all
    select '2022-07-21 06:10:00',894.0,70
    union all
    select '2022-07-21 09:20:00',946.0,59
    union all
    select '2022-07-21 12:29:00',560.0,82
    union all
    select '2022-07-21 14:32:00',538.0,6
    union all
    select '2022-07-21 15:04:00',732.0,81
    union all
    select '2022-07-21 15:41:00',912.0,48
    union all
    select '2022-07-21 17:26:00',500.0,92
    union all
    select '2022-07-21 17:50:00',670.0,73
    union all
    select '2022-07-21 19:21:00',356.0,19
    union all
    select '2022-07-21 20:57:00',756.0,29
    union all
    select '2022-07-21 21:15:00',870.0,19
    union all
    select '2022-07-21 21:45:00',180.0,31
    union all
    select '2022-07-22 00:40:00',844.0,29
    union all
    select '2022-07-22 01:06:00',316.0,52
    union all
    select '2022-07-22 03:19:00',216.0,14
    union all
    select '2022-07-22 04:58:00',134.0,12
    union all
    select '2022-07-22 05:16:00',204.0,6
    union all
    select '2022-07-22 05:23:00',566.0,73
    union all
    select '2022-07-22 05:41:00',730.0,62
    union all
    select '2022-07-22 06:02:00',374.0,87
    union all
    select '2022-07-22 06:59:00',822.0,86
    union all
    select '2022-07-22 08:24:00',204.0,30
    union all
    select '2022-07-22 08:31:00',750.0,2
    union all
    select '2022-07-22 14:21:00',126.0,99
    union all
    select '2022-07-22 16:11:00',400.0,90
    union all
    select '2022-07-22 17:39:00',906.0,67
    union all
    select '2022-07-22 17:52:00',554.0,23
    union all
    select '2022-07-22 18:06:00',200.0,90
    union all
    select '2022-07-22 21:05:00',356.0,6
    union all
    select '2022-07-22 21:27:00',840.0,25
    union all
    select '2022-07-22 22:35:00',832.0,66
    union all
    select '2022-07-22 23:07:00',882.0,9
    union all
    select '2022-07-22 23:36:00',546.0,39
    union all
    select '2022-07-23 00:11:00',702.0,29
    union all
    select '2022-07-23 00:51:00',906.0,27
    union all
    select '2022-07-23 02:24:00',950.0,14
    union all
    select '2022-07-23 07:50:00',464.0,62
    union all
    select '2022-07-23 08:04:00',234.0,42
    union all
    select '2022-07-23 08:43:00',330.0,18
    union all
    select '2022-07-23 08:47:00',996.0,38
    union all
    select '2022-07-23 09:02:00',240.0,81
    union all
    select '2022-07-23 09:02:00',710.0,46
    union all
    select '2022-07-23 09:43:00',416.0,81
    union all
    select '2022-07-23 10:03:00',830.0,42
    union all
    select '2022-07-23 11:07:00',366.0,32
    union all
    select '2022-07-23 11:35:00',206.0,25
    union all
    select '2022-07-23 11:50:00',636.0,43
    union all
    select '2022-07-23 11:53:00',334.0,63
    union all
    select '2022-07-23 13:15:00',272.0,38
    union all
    select '2022-07-23 14:14:00',752.0,61
    union all
    select '2022-07-23 15:03:00',806.0,38
    union all
    select '2022-07-23 16:07:00',456.0,74
    union all
    select '2022-07-23 17:43:00',892.0,32
    union all
    select '2022-07-23 18:06:00',130.0,61
    union all
    select '2022-07-23 18:07:00',310.0,11
    union all
    select '2022-07-23 21:46:00',150.0,50
    union all
    select '2022-07-23 22:04:00',204.0,21
    union all
    select '2022-07-23 22:14:00',486.0,41
    union all
    select '2022-07-23 22:30:00',498.0,12
    union all
    select '2022-07-24 00:18:00',106.0,57
    union all
    select '2022-07-24 01:39:00',344.0,46
    union all
    select '2022-07-24 02:09:00',116.0,13
    union all
    select '2022-07-24 02:58:00',362.0,78
    union all
    select '2022-07-24 04:25:00',892.0,39
    union all
    select '2022-07-24 04:35:00',356.0,25
    union all
    select '2022-07-24 04:45:00',326.0,32
    union all
    select '2022-07-24 04:49:00',866.0,83
    union all
    select '2022-07-24 06:14:00',322.0,61
    union all
    select '2022-07-24 06:17:00',170.0,14
    union all
    select '2022-07-24 06:27:00',792.0,87
    union all
    select '2022-07-24 09:09:00',476.0,49
    union all
    select '2022-07-24 09:40:00',746.0,31
    union all
    select '2022-07-24 09:43:00',568.0,16
    union all
    select '2022-07-24 10:05:00',672.0,29
    union all
    select '2022-07-24 10:27:00',766.0,44
    union all
    select '2022-07-24 11:12:00',200.0,88
    union all
    select '2022-07-24 11:17:00',326.0,87
    union all
    select '2022-07-24 14:42:00',256.0,98
    union all
    select '2022-07-24 15:01:00',510.0,57
    union all
    select '2022-07-24 16:36:00',854.0,21
    union all
    select '2022-07-24 16:40:00',814.0,26
    union all
    select '2022-07-24 17:50:00',264.0,79
    union all
    select '2022-07-24 18:51:00',776.0,76
    union all
    select '2022-07-24 20:31:00',242.0,69
    union all
    select '2022-07-24 21:43:00',140.0,50
    union all
    select '2022-07-24 22:02:00',990.0,9
    union all
    select '2022-07-24 22:47:00',886.0,93
    union all
    select '2022-07-24 22:51:00',486.0,34
    union all
    select '2022-07-25 00:13:00',874.0,9
    union all
    select '2022-07-25 00:24:00',930.0,79
    union all
    select '2022-07-25 00:41:00',300.0,6
    union all
    select '2022-07-25 01:57:00',236.0,33
    union all
    select '2022-07-25 02:23:00',802.0,47
    union all
    select '2022-07-25 02:40:00',622.0,7
    union all
    select '2022-07-25 02:48:00',318.0,44
    union all
    select '2022-07-25 05:13:00',514.0,48
    union all
    select '2022-07-25 06:46:00',150.0,24
    union all
    select '2022-07-25 07:12:00',410.0,66
    union all
    select '2022-07-25 07:13:00',516.0,67
    union all
    select '2022-07-25 08:59:00',818.0,65
    union all
    select '2022-07-25 09:24:00',692.0,83
    union all
    select '2022-07-25 10:32:00',426.0,52
    union all
    select '2022-07-25 10:33:00',704.0,5
    union all
    select '2022-07-25 11:03:00',398.0,13
    union all
    select '2022-07-25 11:19:00',110.0,85
    union all
    select '2022-07-25 12:04:00',230.0,32
    union all
    select '2022-07-25 12:10:00',256.0,44
    union all
    select '2022-07-25 12:33:00',542.0,12
    union all
    select '2022-07-25 13:26:00',440.0,36
    union all
    select '2022-07-25 13:46:00',378.0,32
    union all
    select '2022-07-25 14:15:00',542.0,92
    union all
    select '2022-07-25 14:36:00',532.0,32
    union all
    select '2022-07-25 14:54:00',314.0,15
    union all
    select '2022-07-25 15:49:00',174.0,76
    union all
    select '2022-07-25 16:08:00',696.0,10
    union all
    select '2022-07-25 18:56:00',102.0,62
    union all
    select '2022-07-25 19:18:00',576.0,13
    union all
    select '2022-07-25 19:23:00',586.0,50
    union all
    select '2022-07-25 23:34:00',860.0,68
    union all
    select '2022-07-26 00:10:00',626.0,61
    union all
    select '2022-07-26 00:15:00',648.0,18
    union all
    select '2022-07-26 00:34:00',616.0,10
    union all
    select '2022-07-26 01:22:00',876.0,67
    union all
    select '2022-07-26 02:41:00',128.0,54
    union all
    select '2022-07-26 03:32:00',302.0,11
    union all
    select '2022-07-26 05:08:00',242.0,28
    union all
    select '2022-07-26 07:04:00',984.0,2
    union all
    select '2022-07-26 10:21:00',786.0,10
    union all
    select '2022-07-26 13:02:00',644.0,72
    union all
    select '2022-07-26 14:47:00',108.0,3
    union all
    select '2022-07-26 15:04:00',782.0,14
    union all
    select '2022-07-26 15:20:00',868.0,52
    union all
    select '2022-07-26 15:26:00',426.0,10
    union all
    select '2022-07-26 16:28:00',926.0,39
    union all
    select '2022-07-26 16:37:00',812.0,77
    union all
    select '2022-07-26 19:18:00',502.0,66
    union all
    select '2022-07-26 21:47:00',422.0,61
    union all
    select '2022-07-26 22:15:00',458.0,59
    union all
    select '2022-07-27 00:07:00',280.0,74
    union all
    select '2022-07-27 00:09:00',764.0,43
    union all
    select '2022-07-27 01:13:00',446.0,92
    union all
    select '2022-07-27 01:27:00',582.0,16
    union all
    select '2022-07-27 02:49:00',946.0,36
    union all
    select '2022-07-27 03:06:00',772.0,56
    union all
    select '2022-07-27 03:38:00',234.0,11
    union all
    select '2022-07-27 04:56:00',526.0,26
    union all
    select '2022-07-27 05:29:00',158.0,94
    union all
    select '2022-07-27 07:19:00',614.0,32
    union all
    select '2022-07-27 09:28:00',446.0,15
    union all
    select '2022-07-27 13:03:00',880.0,71
    union all
    select '2022-07-27 13:05:00',504.0,62
    union all
    select '2022-07-27 14:30:00',276.0,51
    union all
    select '2022-07-27 14:56:00',666.0,37
    union all
    select '2022-07-27 14:59:00',884.0,88
    union all
    select '2022-07-27 17:49:00',602.0,27
    union all
    select '2022-07-27 19:04:00',800.0,8
    union all
    select '2022-07-27 19:17:00',668.0,52
    union all
    select '2022-07-27 19:47:00',870.0,1
    union all
    select '2022-07-27 19:58:00',474.0,61
    union all
    select '2022-07-27 22:19:00',912.0,17
    union all
    select '2022-07-27 23:04:00',344.0,91
    union all
    select '2022-07-27 23:05:00',478.0,4
    union all
    select '2022-07-27 23:21:00',490.0,40
    union all
    select '2022-07-28 00:02:00',276.0,40
    union all
    select '2022-07-28 02:18:00',274.0,50
    union all
    select '2022-07-28 03:40:00',590.0,95
    union all
    select '2022-07-28 04:01:00',308.0,54
    union all
    select '2022-07-28 05:19:00',626.0,77
    union all
    select '2022-07-28 06:44:00',278.0,22
    union all
    select '2022-07-28 07:05:00',640.0,83
    union all
    select '2022-07-28 08:36:00',764.0,36
    union all
    select '2022-07-28 08:54:00',302.0,73
    union all
    select '2022-07-28 12:07:00',736.0,30
    union all
    select '2022-07-28 16:04:00',704.0,11
    union all
    select '2022-07-28 16:24:00',624.0,8
    union all
    select '2022-07-28 17:20:00',694.0,77
    union all
    select '2022-07-28 17:57:00',448.0,97
    union all
    select '2022-07-28 18:51:00',510.0,58
    union all
    select '2022-07-28 18:56:00',434.0,98
    union all
    select '2022-07-28 18:58:00',162.0,27
    union all
    select '2022-07-28 19:37:00',398.0,82
    union all
    select '2022-07-28 20:26:00',534.0,31
    union all
    select '2022-07-28 22:00:00',442.0,57
    union all
    select '2022-07-28 22:02:00',128.0,82
    union all
    select '2022-07-29 01:53:00',952.0,32
    union all
    select '2022-07-29 03:23:00',592.0,21
    union all
    select '2022-07-29 05:27:00',552.0,73
    union all
    select '2022-07-29 06:02:00',176.0,37
    union all
    select '2022-07-29 08:11:00',706.0,25
    union all
    select '2022-07-29 08:21:00',254.0,6
    union all
    select '2022-07-29 09:03:00',390.0,32
    union all
    select '2022-07-29 09:24:00',658.0,45
    union all
    select '2022-07-29 14:10:00',944.0,8
    union all
    select '2022-07-29 14:47:00',860.0,73
    union all
    select '2022-07-29 15:29:00',766.0,92
    union all
    select '2022-07-29 16:47:00',782.0,97
    union all
    select '2022-07-29 18:10:00',974.0,35
    union all
    select '2022-07-29 18:25:00',960.0,56
    union all
    select '2022-07-29 19:55:00',626.0,23
    union all
    select '2022-07-29 20:25:00',196.0,76
    union all
    select '2022-07-29 21:25:00',436.0,55
    union all
    select '2022-07-29 21:33:00',624.0,23
    union all
    select '2022-07-29 21:40:00',194.0,79
    union all
    select '2022-07-29 21:48:00',142.0,79
    union all
    select '2022-07-29 21:52:00',784.0,88
    union all
    select '2022-07-29 22:05:00',988.0,27
    union all
    select '2022-07-29 23:14:00',434.0,79
    union all
    select '2022-07-29 23:15:00',794.0,41
    union all
    select '2022-07-30 00:44:00',896.0,22
    union all
    select '2022-07-30 01:39:00',286.0,1
    union all
    select '2022-07-30 03:13:00',172.0,44
    union all
    select '2022-07-30 03:31:00',134.0,70
    union all
    select '2022-07-30 03:38:00',736.0,48
    union all
    select '2022-07-30 05:13:00',618.0,78
    union all
    select '2022-07-30 06:50:00',698.0,34
    union all
    select '2022-07-30 07:03:00',372.0,10
    union all
    select '2022-07-30 07:06:00',504.0,76
    union all
    select '2022-07-30 07:10:00',364.0,59
    union all
    select '2022-07-30 07:10:00',228.0,86
    union all
    select '2022-07-30 07:37:00',402.0,83
    union all
    select '2022-07-30 10:44:00',136.0,82
    union all
    select '2022-07-30 12:24:00',500.0,65
    union all
    select '2022-07-30 13:24:00',892.0,37
    union all
    select '2022-07-30 14:04:00',116.0,5
    union all
    select '2022-07-30 14:38:00',300.0,13
    union all
    select '2022-07-30 15:32:00',694.0,86
    union all
    select '2022-07-30 16:02:00',588.0,61
    union all
    select '2022-07-30 20:53:00',174.0,40
    union all
    select '2022-07-30 21:15:00',584.0,77
    union all
    select '2022-07-30 21:38:00',154.0,57
    union all
    select '2022-07-30 22:17:00',278.0,23
    union all
    select '2022-07-31 00:23:00',280.0,52
    union all
    select '2022-07-31 01:40:00',854.0,77
    union all
    select '2022-07-31 01:43:00',450.0,16
    union all
    select '2022-07-31 02:24:00',166.0,41
    union all
    select '2022-07-31 02:28:00',844.0,81
    union all
    select '2022-07-31 03:00:00',998.0,60
    union all
    select '2022-07-31 03:40:00',336.0,94
    union all
    select '2022-07-31 03:45:00',976.0,98
    union all
    select '2022-07-31 03:46:00',568.0,82
    union all
    select '2022-07-31 04:58:00',684.0,19
    union all
    select '2022-07-31 07:33:00',504.0,28
    union all
    select '2022-07-31 08:30:00',932.0,94
    union all
    select '2022-07-31 09:25:00',154.0,28
    union all
    select '2022-07-31 09:37:00',986.0,51
    union all
    select '2022-07-31 11:15:00',950.0,4
    union all
    select '2022-07-31 13:32:00',834.0,41
    union all
    select '2022-07-31 14:20:00',464.0,18
    union all
    select '2022-07-31 18:11:00',966.0,3
    union all
    select '2022-07-31 18:29:00',204.0,44
    union all
    select '2022-07-31 19:13:00',126.0,92
    union all
    select '2022-07-31 20:08:00',564.0,51
    union all
    select '2022-07-31 21:16:00',864.0,26
    union all
    select '2022-07-31 21:16:00',482.0,51
    union all
    select '2022-07-31 22:16:00',336.0,13
)
select count(1) from cte_av_table_none
