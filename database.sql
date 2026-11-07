-- ============================================================
-- CyberShield - Database MySQL
-- Aplikasi: CyberShield (Network Security Dashboard)
-- UTS Keamanan Jaringan - Ahmad Muqarrobin (242502040003)
-- ============================================================
-- Cara pakai (XAMPP / phpMyAdmin):
--   1. Buka phpMyAdmin, pilih tab "Import".
--   2. Pilih file ini (database.sql), lalu klik "Go".
--   3. Database "cybershield" beserta 3 tabel dan data awal
--      akan dibuat otomatis.
-- Alternatif lewat terminal:
--   mysql -u root -p < database.sql
-- ============================================================

CREATE DATABASE IF NOT EXISTS cybershield
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE cybershield;

-- ------------------------------------------------------------
-- Tabel 1: firewall_rules
-- Menyimpan aturan firewall: IP/CIDR, port, protokol,
-- tindakan (ALLOW / BLOCK), dan status aktif.
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS firewall_rules (
  id        INT UNSIGNED NOT NULL AUTO_INCREMENT,
  ip        VARCHAR(43)  NOT NULL COMMENT 'Alamat IP, CIDR (cth: 192.168.1.0/24), atau "any"',
  port      VARCHAR(5)   NOT NULL DEFAULT 'any' COMMENT 'Nomor port 1-65535 atau "any"',
  protocol  ENUM('ANY','TCP','UDP') NOT NULL DEFAULT 'ANY',
  action    ENUM('ALLOW','BLOCK')   NOT NULL DEFAULT 'BLOCK',
  active    TINYINT(1)   NOT NULL DEFAULT 1 COMMENT '1 = aktif, 0 = nonaktif',
  created_at TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO firewall_rules (id, ip, port, protocol, action, active) VALUES
  (1, '192.168.1.0/24', 'any', 'ANY', 'ALLOW', 1),
  (2, '192.168.1.0/24', '443', 'TCP', 'ALLOW', 1),
  (3, '45.227.45.12',   'any', 'ANY', 'BLOCK', 1),
  (4, 'any',            '23',  'TCP', 'BLOCK', 1);

-- ------------------------------------------------------------
-- Tabel 2: security_logs
-- Mencatat setiap kejadian keamanan: waktu, IP sumber,
-- port tujuan, jenis aktivitas, dan tindakan sistem.
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS security_logs (
  id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  time        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Waktu kejadian',
  source_ip   VARCHAR(43) NOT NULL COMMENT 'IP sumber koneksi',
  dest_port   INT UNSIGNED NOT NULL COMMENT 'Port tujuan',
  activity    VARCHAR(100) NOT NULL COMMENT 'Jenis aktivitas, cth: HTTP, Port Scan, Brute Force SSH',
  action      ENUM('ALLOW','BLOCK') NOT NULL COMMENT 'Tindakan sistem: DIIZINKAN / DIBLOKIR',
  PRIMARY KEY (id),
  INDEX idx_source_ip (source_ip),
  INDEX idx_action (action),
  INDEX idx_time (time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO security_logs (time, source_ip, dest_port, activity, action) VALUES
  (NOW() - INTERVAL 2 MINUTE,  '45.227.45.12',  22,   'Brute Force SSH', 'BLOCK'),
  (NOW() - INTERVAL 5 MINUTE,  '192.168.1.24',  443,  'HTTPS',           'ALLOW'),
  (NOW() - INTERVAL 9 MINUTE,  '185.220.101.47', 22,   'Brute Force SSH', 'BLOCK'),
  (NOW() - INTERVAL 14 MINUTE, '192.168.1.31',  53,   'DNS Query',       'ALLOW'),
  (NOW() - INTERVAL 21 MINUTE, '103.75.190.8',  4444, 'Malware C2',      'BLOCK'),
  (NOW() - INTERVAL 28 MINUTE, '192.168.1.15',  80,   'HTTP',            'ALLOW'),
  (NOW() - INTERVAL 35 MINUTE, '203.0.113.44',  3389, 'Port Scan',       'BLOCK'),
  (NOW() - INTERVAL 47 MINUTE, '192.168.1.42',  3306, 'MySQL',           'ALLOW');

-- ------------------------------------------------------------
-- Tabel 3: blacklist_ips
-- Daftar IP yang diblokir beserta alasan dan waktu ditambahkan.
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS blacklist_ips (
  ip        VARCHAR(43)  NOT NULL,
  reason    VARCHAR(255) NOT NULL COMMENT 'Alasan pemblokiran',
  added_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (ip)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO blacklist_ips (ip, reason, added_at) VALUES
  ('45.227.45.12',   'Port scan berulang',         NOW() - INTERVAL 3 HOUR),
  ('185.220.101.47', 'Percobaan brute force SSH',  NOW() - INTERVAL 5 HOUR),
  ('103.75.190.8',   'Distribusi malware (C2)',    NOW() - INTERVAL 10 HOUR);

-- ============================================================
-- Catatan:
-- Aplikasi demo (index.html) memakai localStorage di browser
-- sehingga bisa berjalan tanpa server (mis. GitHub Pages).
-- Skema di atas adalah struktur database MySQL yang sama,
-- siap dipakai saat aplikasi dihubungkan ke backend PHP.
-- ============================================================
