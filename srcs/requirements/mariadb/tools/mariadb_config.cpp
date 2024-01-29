#include <cstdlib>
#include <iostream>
#include <fstream>
#include <vector>
#include <map>
#include <sstream>
#include <string>

std::map<std::string, std::string> load_env_variables() {
    std::map<std::string, std::string> env_vars;
    const char* vars[] = {"MYSQL_DB", "MYSQL_USER", "MYSQL_PASSWORD", "MYSQL_ROOT_PASSWORD", "WP_DB", "WP_DB_USER", "WP_DB_PASSWD", nullptr};

    for (const char** var = vars; *var != nullptr; ++var) {
        const char* value = std::getenv(*var);
        if (value != nullptr) {
            env_vars[*var] = value;
        }
    }

    return env_vars;
}

void create_sql_command(const std::map<std::string, std::string>& env_vars)
{
	std::ofstream db_file("WP_DB.sql");
	if (!db_file) {
        std::cerr << "Impossibile aprire o creare il file." << "\n";
        return;
    }
	db_file << "CREATE DATABASE IF NOT EXISTS `" << env_vars.at("MYSQL_DB") << "`;\n";
	db_file << "CREATE USER IF NOT EXISTS '" << env_vars.at("MYSQL_USER") << "'@'%' IDENTIFIED BY '" << env_vars.at("MYSQL_PASSWORD") << "';\n";
	db_file << "GRANT ALL PRIVILEGES ON `" << env_vars.at("MYSQL_DB") << "`.* TO '" << env_vars.at("MYSQL_USER") << "'@'%';\n";
	db_file << "ALTER USER 'root'@'localhost' IDENTIFIED BY '" << env_vars.at("MYSQL_ROOT_PASSWORD") << "';\n";
	db_file << "FLUSH PRIVILEGES;\n";
	db_file.close();
}

int main()
{
	std::ifstream file("/etc/mysql/mariadb.conf.d/50-server.cnf");
	std::vector<std::string> lines;

    if (!file) {
        std::cerr << "Impossibile aprire il file per la lettura." << "\n";
        return 1;
    }
	std::string line;
    while (std::getline(file, line))
	{
		if (line.find("bind-address") != std::string::npos)
		{
            line = "bind-address            = 0.0.0.0";
        }
		lines.push_back(line);
        std::cout << line << "\n";
    }

    file.close();

	std::ofstream db_file("/etc/mysql/mariadb.conf.d/50-server.cnf");
    if (!db_file) {
        std::cerr << "Impossibile aprire il file per la scrittura." << "\n";
        return 1;
    }

    for (const auto& modified_line : lines) {
        db_file << modified_line << "\n";
    }

    db_file.close();
	auto env_vars = load_env_variables();
	create_sql_command(env_vars);
    return 0;
}
