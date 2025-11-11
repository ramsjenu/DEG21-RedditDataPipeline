#!/bin/bash
set -e

# Define the database name and SQLAlchemy URI
DB_NAME="dataengineering"
SQLALCHEMY_URI="hive://hive@hiveserver2:10000/dataengineering"

echo "🔍 Checking if database '$DB_NAME' exists in Superset..."

# Check existing databases using Superset Python shell
EXISTING_DB=$(superset shell -c "from superset import db; from superset.models.core import Database; print([d.database_name for d in db.session.query(Database).all()])" | grep "$DB_NAME" || true)

if [ -z "$EXISTING_DB" ]; then
  echo "🆕 Database '$DB_NAME' does not exist. Adding it now..."
  superset set_database_uri --database_name "$DB_NAME" --uri "$SQLALCHEMY_URI"
else
  echo "✅ Database '$DB_NAME' already exists. Skipping creation."
fi

echo "🎉 Superset connection setup complete!"
