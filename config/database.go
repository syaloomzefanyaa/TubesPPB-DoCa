package config

import (
    "database/sql"
    "fmt"
    "log"

    _"github.com/go-sql-driver/mysql"
)

var DB *sql.DB

func ConnectDatabase() {
    var err error
    dbConnect := "root@tcp(127.0.0.1:3306)/docadb"
    DB, err = sql.Open("mysql", dbConnect)
    if err != nil {
        log.Fatal(err)
    }

    // Test database connection
    err = DB.Ping()
    if err != nil {
        log.Fatal(err)
    }

    fmt.Println("Database connected successfully")
}