-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Waktu pembuatan: 12 Jun 2024 pada 21.14
-- Versi server: 10.4.22-MariaDB
-- Versi PHP: 8.1.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `docadb`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `pet`
--

CREATE TABLE `pet` (
  `id_pet` int(50) NOT NULL,
  `id_user` int(50) NOT NULL,
  `name_pet` text NOT NULL,
  `type_pet` text NOT NULL,
  `breed_pet` text NOT NULL,
  `sex` enum('male','female') NOT NULL,
  `weight_pet` varchar(255) NOT NULL,
  `color_pet` varchar(255) NOT NULL,
  `image_pet` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `pet`
--

INSERT INTO `pet` (`id_pet`, `id_user`, `name_pet`, `type_pet`, `breed_pet`, `sex`, `weight_pet`, `color_pet`, `image_pet`) VALUES
(3, 1, 'Jojo', 'Dog', 'Golden Retriever', 'male', '88', 'brown', '/uploads/0ae74fe4d2ec6df07bc531133e91ac79f55b995802d202a15824356b287d817c.jpg'),
(4, 1, 'Nadin', 'Dog', 'Poodle', 'male', '5', 'white', '/uploads/efe687e34fa988741257e2e7cf20b93c1797312ed913f8ef6aed147210d59b01.jpg'),
(5, 2, 'Nari', 'Dog', 'Siberian Husky', 'male', '12', 'white', '/uploads/efe687e34fa988741257e2e7cf20b93c1797312ed913f8ef6aed147210d59b01.jpg'),
(11, 1, 'uus', 'Dog', 'Beagle', 'female', '50', 'black and brown', '/uploads/26093fb83af5cca9c19175c7aa63fca93c6041209dcfb33aae10b306b3794f5a.jpg'),
(12, 7, 'tutu', 'Dog', 'Beagle', 'female', '21', 'brown', '/uploads/664c2357dcfcaa84abc5bfa14b2679e363b01a4e036d196b788aeb34ee803a98.jpg'),
(13, 12, 'gygy', 'Dog', 'Bulldog', 'female', '20', 'brown', '/uploads/f6369bd47e8b3d5663baedc3fea93d03bc34310cad4bc746374d6235cd48c249.jpg'),
(14, 12, 'gygy', 'Dog', 'Bulldog', 'female', '20', 'brown', '/uploads/f6369bd47e8b3d5663baedc3fea93d03bc34310cad4bc746374d6235cd48c249.jpg'),
(15, 13, 'Leoo', 'Cat', 'Labrador Retriever', 'female', '23', 'white', '/uploads/4aa5c5bff9ac128ded657c2895adb251de7e73778adeb715b34f60866d010825.jpg'),
(16, 14, 'bula', 'Cat', 'German Shepherd', 'female', '23', 'white', '/uploads/06e18827c18920d383e970627a62cfeb29f0ae074e64e34c7f83438ce95533c6.jpg'),
(17, 15, 'tokyo', 'Dog', 'Golden Retriever', 'male', '23', 'red', '/uploads/1aff8bfc15cd22ee78e6bb593c11ad804514a190bc4a41f207062f34d6613b8e.jpg'),
(18, 16, 'hahajubelum', 'Cat', 'Labrador Retriever', 'female', '23', 'white and brown', 'http://192.168.251.42:8000/uploads/6643518f14e843d89da802b573893cc33bf65f2b5ebdc475b751dbd8dd212f55.jpg');

-- --------------------------------------------------------

--
-- Struktur dari tabel `product`
--

CREATE TABLE `product` (
  `id_product` int(50) NOT NULL,
  `name_product` varchar(100) NOT NULL,
  `description` varchar(255) NOT NULL,
  `price` int(100) NOT NULL,
  `image_product` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `product`
--

INSERT INTO `product` (`id_product`, `name_product`, `description`, `price`, `image_product`) VALUES
(1, '', 'Ini makanan anji', 50000, '/uploads/8f66a618c8b149dee28e092aab3f43cb2a6acbb9e0081b56ae7970195f0198d5.JPG'),
(2, '', 'Ini makanan anjing dep', 50000, 'http://localhost:3000/uploads/6d4291992496c3260b884c9dafba4b2d19917f4f192e85bbaf54688dcd52fe01.png'),
(3, '', 'Ini makanan anjing dep', 50000, 'http://localhost:3000/uploads/2e03702b59e4e188ae7b11c4ac1c4701e46841e4d1950f51a0440d157ded8d8d.png'),
(4, 'Bola Anjing new', 'ini merupakan bola anjing', 150, '/uploads\\f5e804dc6c2ad41bbb6d5158fc80d496f87a463cc28492f8f96a2ad9b8b3c3f2.jpg'),
(5, 'Bola Anjing new', 'ini merupakan bola anjing', 250004, '/uploads/efe687e34fa988741257e2e7cf20b93c1797312ed913f8ef6aed147210d59b01.jpg');

-- --------------------------------------------------------

--
-- Struktur dari tabel `task_user`
--

CREATE TABLE `task_user` (
  `id_task` int(50) NOT NULL,
  `id_user` int(50) NOT NULL,
  `id_pet` int(50) NOT NULL,
  `category` varchar(255) NOT NULL,
  `date` datetime NOT NULL,
  `description` varchar(255) NOT NULL,
  `is_done` enum('1','2') NOT NULL DEFAULT '2'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `task_user`
--

INSERT INTO `task_user` (`id_task`, `id_user`, `id_pet`, `category`, `date`, `description`, `is_done`) VALUES
(3, 1, 3, 'Food', '2024-06-10 09:00:00', 'Berenang bersama lindah', '1'),
(4, 1, 4, 'Food', '2024-06-10 09:00:00', 'Berenang bersama nando', '1'),
(5, 1, 4, 'Hygene', '2024-06-10 09:00:00', 'Perawatan bersama nando', '1'),
(7, 1, 3, 'Hygene', '2024-06-11 09:00:00', 'Perawatan bersama linda', '1'),
(14, 1, 3, 'Activities', '2024-06-11 00:00:00', 'hhhhhh', '1'),
(19, 1, 4, 'Hygiene', '2024-06-11 00:00:00', 'ggggg', '1'),
(20, 16, 18, 'Hygiene', '2024-06-12 00:00:00', 'Membawa haha perawatan', '2');

-- --------------------------------------------------------

--
-- Struktur dari tabel `user`
--

CREATE TABLE `user` (
  `id_user` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `image` varchar(500) NOT NULL DEFAULT '/uploads\\098ae889bf875e529e6c5efff483a6894067774f18479af3da0156825ee3837b.png',
  `isLogin` enum('1','2') NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `user`
--

INSERT INTO `user` (`id_user`, `username`, `email`, `password`, `image`, `isLogin`) VALUES
(1, 'budi12345', 'budi13@gmail.com', '12345678', '/uploads/b6cb334ec1b33e9cd2bbaab207ee4ab8ee7244860c3fda66dd2d3ffaa7e99ce5.jpg', '1'),
(2, 'budi', 'budi14@gmail.com', '12345678', '/uploads\\098ae889bf875e529e6c5efff483a6894067774f18479af3da0156825ee3837b.png', '1'),
(3, 'budi11', 'budi15@gmail.com', '12345678', '/uploads\\098ae889bf875e529e6c5efff483a6894067774f18479af3da0156825ee3837b.png', '2'),
(4, 'Budianto11', 'budi16@gmail.com', '12345678', '/uploads\\098ae889bf875e529e6c5efff483a6894067774f18479af3da0156825ee3837b.png', '2'),
(5, 'monmonn', 'mon124@gmail.com', '12345678', '/uploads/efe687e34fa988741257e2e7cf20b93c1797312ed913f8ef6aed147210d59b01.jpg', '2'),
(6, 'Monika12', 'mon11@gmail.com', '12345678', '/uploads\\098ae889bf875e529e6c5efff483a6894067774f18479af3da0156825ee3837b.png', '2'),
(7, 'Syaloom12', 'syaa12@gmail.com', '12345678', 'http://192.168.251.42:8000/uploads/7da826ab230c2b69f68f443542ca8b572a60ba9ebf173cd208d378813a85e9a2.jpg', '2'),
(8, 'Budianto11', 'budi17@gmail.com', '12345678', '/uploads\\098ae889bf875e529e6c5efff483a6894067774f18479af3da0156825ee3837b.png', '1'),
(9, 'HansAgun18', 'hansagg11@gmail.com', '12345678', '/uploads\\098ae889bf875e529e6c5efff483a6894067774f18479af3da0156825ee3837b.png', '1'),
(10, 'Budianto11', 'budi19@gmail.com', '12345678', '/uploads\\098ae889bf875e529e6c5efff483a6894067774f18479af3da0156825ee3837b.png', '1'),
(11, 'Budianto11', 'budi20@gmail.com', '12345678', '/uploads\\098ae889bf875e529e6c5efff483a6894067774f18479af3da0156825ee3837b.png', '1'),
(12, 'Bayu1234', 'bayu11@gmail.com', '12345678', '/uploads\\098ae889bf875e529e6c5efff483a6894067774f18479af3da0156825ee3837b.png', '1'),
(13, 'LeonalOJ123', 'leo11@gmail.com', '12345678', '/uploads\\098ae889bf875e529e6c5efff483a6894067774f18479af3da0156825ee3837b.png', '1'),
(14, 'Sayangku12', 'sayangku17@gmail.com', '12345678', '/uploads\\098ae889bf875e529e6c5efff483a6894067774f18479af3da0156825ee3837b.png', '2'),
(15, 'Ayusinta12', 'ayu11@gmail.com', '12345678', '/uploads\\098ae889bf875e529e6c5efff483a6894067774f18479af3da0156825ee3837b.png', '1'),
(16, 'Hahaha12', 'haha11@gmail.com', '12345678', '/uploads\\098ae889bf875e529e6c5efff483a6894067774f18479af3da0156825ee3837b.png', '1');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `pet`
--
ALTER TABLE `pet`
  ADD PRIMARY KEY (`id_pet`),
  ADD KEY `fk_user1` (`id_user`);

--
-- Indeks untuk tabel `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`id_product`);

--
-- Indeks untuk tabel `task_user`
--
ALTER TABLE `task_user`
  ADD PRIMARY KEY (`id_task`),
  ADD KEY `fk_user2` (`id_user`),
  ADD KEY `fk_pet1` (`id_pet`);

--
-- Indeks untuk tabel `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id_user`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `pet`
--
ALTER TABLE `pet`
  MODIFY `id_pet` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT untuk tabel `product`
--
ALTER TABLE `product`
  MODIFY `id_product` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `task_user`
--
ALTER TABLE `task_user`
  MODIFY `id_task` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT untuk tabel `user`
--
ALTER TABLE `user`
  MODIFY `id_user` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `pet`
--
ALTER TABLE `pet`
  ADD CONSTRAINT `fk_user1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `task_user`
--
ALTER TABLE `task_user`
  ADD CONSTRAINT `fk_pet1` FOREIGN KEY (`id_pet`) REFERENCES `pet` (`id_pet`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user2` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
