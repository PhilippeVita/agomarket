-- 00_init_database.sql
-- Initialisation complète du DWH AgoMarket dans Docker
-- Base : agomarket-dwh
-- Schéma : agomarket
-- Utilisateur : agomarket

------------------------------------------------------------
-- Extensions nécessaires
------------------------------------------------------------
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

------------------------------------------------------------
-- Création du schéma dédié AgoMarket
------------------------------------------------------------
CREATE SCHEMA IF NOT EXISTS agomarket AUTHORIZATION agomarket;

------------------------------------------------------------
-- Droits sur le schéma
------------------------------------------------------------
ALTER SCHEMA agomarket OWNER TO agomarket;

------------------------------------------------------------
-- Search path pour l'utilisateur agomarket
-- Priorité au schéma agomarket, puis public
------------------------------------------------------------
ALTER ROLE agomarket SET search_path TO agomarket, public;

------------------------------------------------------------
-- Vérification : forcer le search_path pour la session courante
------------------------------------------------------------
SET search_path TO agomarket, public;