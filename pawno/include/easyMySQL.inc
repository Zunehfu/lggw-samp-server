#include <a_samp>
#include <a_mysql>

/*
native MySQLConnect(const host[] = MYSQL_SERVER, const user[] = MYSQL_UID, const database[] = MYSQL_DATABASE, const password[] = MYSQL_PASSWORD, port = 3306, bool:autoreconnect = true, pool_size = 2)
native MySQLDisconnect();
native CreateRow(table[], const column[], { _,Float }:...)
native RetrieveKey(table[], key[], keys[] = "", size = sizeof (keys), const column[], { _,Float }:...)
native VerifyTable(table[], key[], bool:ai = true)
native VerifyColumn(table[], column[], DBType:type, len, { _,Float }:...)
native SetFloatEntry(table[], key[], keys, const column[], Float:value)
native SetStringEntry(table[], key[], keys, const column[], const value[])
native SetIntEntry(table[], key[], keys, const column[], value)
*/

#if ! defined MYSQL_DATABASE
    #define MYSQL_DATABASE "test"
#endif

#if ! defined MYSQL_SERVER
	#define MYSQL_SERVER "127.0.0.1"
#endif

#if ! defined MYSQL_UID
	#define MYSQL_UID "root"
#endif

#if ! defined MYSQL_PASSWORD
	#define MYSQL_PASSWORD ""
#endif

#if ! defined MySQL_MAX_NAME
	#define MySQL_MAX_NAME (45)
#endif

#if ! defined MySQL_MAX_ENTRY
	#define MySQL_MAX_ENTRY (1024)
#endif

#if ! defined MySQL_MAX_QUERY
	#define MySQL_MAX_QUERY (3024)
#endif

#define MySQL_INVALID           	(0)
#define MySQL_INVALID_KEY      		(0)

// variables for mysql

new mysql;
new g_Query[MySQL_MAX_QUERY];

//column types enum
enum DBType
{
	TYPE_NUMBER,
	TYPE_FLOAT,
	TYPE_STRING
}

stock MySQLConnect(const host[] = MYSQL_SERVER, const user[] = MYSQL_UID, const database[] = MYSQL_DATABASE, const password[] = MYSQL_PASSWORD, port = 3306, bool:autoreconnect = true, pool_size = 2)
{
    mysql = mysql_connect(host, user, database, password, port, autoreconnect, pool_size);
    if(mysql_errno() == 0 )
    {
		printf("Connection to the host and database has been established. (Host: %s | DB: %s)", host, database);
		print("EasyMySQL build 1.2 has been loaded");
		return 1;
	}
	else
	{
		printf("Connection to the host and database could not be established. (Host: %s | DB: %s)", host, database);
		return 0;
	}
}

stock MySQLDisconnect()
{
	mysql_close(mysql);
	return 1;
}

stock VerifyTable(table[], key[], bool:ai = true)
{
    g_Query[0] = EOS;

    strcat(g_Query, "SELECT * FROM `");
    strcat(g_Query, table);
	strcat(g_Query, "` LIMIT 1");

	new Cache:result = mysql_query(mysql, g_Query);
	
	if(!result)
	{
	    printf("Table '%s' does not seem to exist; attempting to create it.", table);
	    
	    g_Query[0] = EOS;
	    
		strcat(g_Query, "CREATE TABLE `");
		strcat(g_Query, table);
		strcat(g_Query, "` (`");
		strcat(g_Query, key);
		if(ai == true)
		{
			strcat(g_Query, "` INTEGER PRIMARY KEY AUTO_INCREMENT)");
		}
		else strcat(g_Query, "` INTEGER PRIMARY KEY)");
		
		mysql_query(mysql, g_Query);
		
		g_Query[0] = EOS;
		
		strcat(g_Query, "SELECT * FROM `");
	    strcat(g_Query, table);
		strcat(g_Query, "` LIMIT 1");

		result = mysql_query(mysql, g_Query);
		
		if(result)
		{
		    printf("Table '%s' has been created successfully; key: %s.", table, key);
		    cache_delete(result);
		}
		else
		{
		    printf("Table '%s' could not be created.", table, key);
		    cache_delete(result);
		}
	}
	return 1;
}

stock VerifyColumn(table[], column[], DBType:type, len, { _,Float }:...)
{
    g_Query[0] = EOS;
    strcat(g_Query, "SELECT `");
    strcat(g_Query, column);
    strcat(g_Query, "` FROM `");
    strcat(g_Query, table);
    strcat(g_Query, "` LIMIT 1");

	new Cache:result = mysql_query(mysql, g_Query);
	if (! result)
	{
		printf("The column \"%s\" doesn't exist; attempting to create it.", column);

		switch (type)
		{
			case TYPE_NUMBER:
			{
				new default_value = 0;
				if (numargs() == 4)
				{
					default_value = getarg(3);
				}

				format(g_Query, MySQL_MAX_QUERY, "ALTER TABLE `%s` ADD COLUMN `%s` INTEGER(%d) DEFAULT %d", table, column, len,  default_value);
			}

			case TYPE_FLOAT:
			{
				new Float:default_value = 0.0;
				if (numargs() != 4)
				{
					default_value = Float:getarg(3);
				}

				format(g_Query, MySQL_MAX_QUERY, "ALTER TABLE `%s` ADD COLUMN `%s` FLOAT(%d) DEFAULT %f", table, column, len, default_value);
			}

			case TYPE_STRING:
			{
				new default_value[1024 * 2] = "";
				if (numargs() == 4)
				{
					getstringarg(default_value, 3);
				}

				format(g_Query, MySQL_MAX_QUERY, "ALTER TABLE `%s` ADD COLUMN `%s` VARCHAR(%d) DEFAULT '%s'", table, column, len,  default_value);
			}
		}

		result = mysql_query(mysql, g_Query);

		if (result)
		{
		    cache_delete(result);
		    return 1;
		}
		else
		{
		    cache_delete(result);
		    printf("Failed to create the column \"%s\"; this could be because of an invalid column name.", column);
		    return MySQL_INVALID;
		}
	}
	return 1;
}

stock RetrieveKey(table[], key[], keys[] = "", size = sizeof (keys), const column[], { _,Float }:...)
{
    if (numargs() != 6)
	{
		return MySQL_INVALID_KEY;
	}

	new args[MySQL_MAX_ENTRY * 2];
	getstringarg(args, 5);

	mysql_format(mysql, g_Query, MySQL_MAX_QUERY, "SELECT `%s` FROM `%s` WHERE `%s` = '%e'", key, table, column, args);

	new Cache:result = mysql_query(mysql, g_Query);
	
	if (result)
	{
	    if (size == 1)
	    {
			new keyx = cache_get_field_content_int(0, key);
			if(keyx != MySQL_INVALID_KEY)
			{
				return keyx;
			}
	    }
		else
		{
			new rows = cache_num_rows();

			for (new i; i < size; i++)
			{
				if (i < rows)
				{
					keys[i] = cache_get_field_content_int(i, key);
				}
				else
				{
					keys[i] = MySQL_INVALID_KEY;
				}
			}
			
			return keys[0];
		}
	}

	cache_delete(result);
	
	return MySQL_INVALID_KEY;
}

stock CreateRow(table[], const column[], { _,Float }:...)
{
    if (numargs() != 3)
	{
		return false;
	}

	new args[MySQL_MAX_ENTRY * 2];
	getstringarg(args, 2);

    mysql_format(mysql, g_Query, MySQL_MAX_QUERY, "INSERT INTO `%s`(`%s`) VALUES('%e')", table, column, args);
	new Cache:result = mysql_query(mysql, g_Query);
	new id = cache_insert_id();
	cache_delete(result);
	return id;
}

stock SetIntEntry(table[], key[], keys, const column[], value)
{
	g_Query[0] = EOS;

	format(g_Query, MySQL_MAX_QUERY, "UPDATE `%s` SET `%s` = '%d' WHERE `%s` = '%d'", table, column, value, key, keys);

	mysql_tquery(mysql, g_Query, "", "");
	if(mysql_errno() == 0 )
    {
		return 1;
	}
	else
	{
		return 0;
	}
}

stock SetFloatEntry(table[], key[], keys, const column[], Float:value)
{
	format(g_Query, MySQL_MAX_QUERY, "UPDATE `%s` SET `%s` = '%f' WHERE `%s` = '%d'", table, column, value, key, keys);
	mysql_tquery(mysql, g_Query, "", "");
	if(mysql_errno() == 0 )
    {
		return 1;
	}
	else
	{
		return 0;
	}
}

stock SetStringEntry(table[], key[], keys, const column[], const value[])
{
	mysql_format(mysql, g_Query, MySQL_MAX_QUERY, "UPDATE `%s` SET `%s` = '%q' WHERE `%s` = '%d'", table, column, value, key, keys);

	mysql_tquery(mysql, g_Query, "", "");
	if(mysql_errno() == 0 )
    {
		return 1;
	}
	else
	{
		return 0;
	}
}

stock bool:MultiSet(table[], key[], keys, const fmat[], {_, Float}:...)
{
    g_Query[0] = EOS;

	for (new i, j = strlen(fmat); i < j; i++)
	{
		switch (fmat[i])
		{
			case 'i', 'd', 'f', 's':
			{
			}
			default:
			{
				return false;
			}
		}
	}

	new column[MySQL_MAX_NAME];
	new column_arg;
	new value[MySQL_MAX_ENTRY * 2];

	g_Query = "UPDATE `";
	strcat(g_Query, table);
	strcat(g_Query, "` SET ");

	for (new i, j = strlen(fmat); i < j; i++)
	{
		column_arg = 4 + i * 2;

		getstringarg(column, column_arg);

		++column_arg;

		strcat(g_Query, "`");
		strcat(g_Query, column);
		strcat(g_Query, "` = '");

		switch (fmat[i])
		{
			case 'i', 'd':
			{
				valstr(value, getarg(column_arg));
			}
			case 'f':
			{
				format(value, sizeof(value), "%f", Float:getarg(column_arg));
			}
			case 's':
			{
				getstringarg(value, column_arg, MySQL_MAX_ENTRY);
			}
		}

		strcat(g_Query, value);
		strcat(g_Query, "'");

		if (i < j - 1)
		{
			strcat(g_Query, ", ");
		}
	}

	valstr(value, keys);

	strcat(g_Query, " WHERE `");
	strcat(g_Query, key);
	strcat(g_Query, "` = '");
	strcat(g_Query, value);
	strcat(g_Query, "'");

	mysql_tquery(mysql, g_Query, "", "");
	return true;
}

stock bool:MultiGet(table[], key[], keys, const fmat[], {_, Float}:...)
{
	new column[MySQL_MAX_NAME];
	new column_arg;

	g_Query = "SELECT `";

	for (new i, j = strlen(fmat); i < j; i++)
	{
		column_arg = 4 + i * 2;

		getstringarg(column, column_arg);

		strcat(g_Query, column);

		if (i < j - 1)
		{
			strcat(g_Query, "`, `");
		}
	}

	strcat(g_Query, "` FROM `");
	strcat(g_Query, table);
	strcat(g_Query, "` WHERE `");
	strcat(g_Query, key);
	strcat(g_Query, "` = '");
	
	new valuex[11];
	valstr(valuex,keys);
	
	strcat(g_Query, valuex);
	strcat(g_Query, "'");

	new Cache:result = mysql_query(mysql, g_Query);
	
	if (result)
	{
	    if (! cache_num_rows())
	    {
			cache_delete(result);
			return false;
	    }

	    new str[MySQL_MAX_ENTRY];
		for (new i, j = cache_num_rows(); i < j; i++)
		{
			new arg[50];
			format(arg, sizeof arg, column);
			switch (fmat[i])
			{
				case 'i', 'd':
				{
					setarg((4 + i * 2) + 1, .value = cache_get_field_content_int(i, arg));
				}
				case 'f':
				{
					setarg((4 + i * 2) + 1, .value = _:cache_get_field_content_float(i, arg));
				}
				case 's':
				{
					cache_get_field_content(i, arg, str);
					setstringarg((4 + i * 2) + 1, str);
   				}
			}
		}

		cache_delete(result);
		return true;
	}
	return false;
}

forward OnNewRowIsCreated();
public OnNewRowIsCreated()
{
	return cache_insert_id();
}

stock static setstringarg(arg, const value[], len = sizeof (value))
{
	new address;

	// Get the address of the previous function's stack.  First get the index of
    // the argument required.
    #emit LOAD.S.pri arg

    // Then convert that number to bytes from cells.
    #emit SMUL.C     4

    // Get the previous function's frame.
	#emit LOAD.S.alt 0

	// Add the frame pointer to the argument offset in bytes.
    #emit ADD

    // Add 12 to skip over the function header.
    #emit ADD.C      12

    // Load the address stored in the specified address.
    #emit LOAD.I
	#emit STOR.S.PRI address

	// Push the length (last argument first)
	#emit PUSH.S     len

	// Push the new value (source) value
	#emit PUSH.S     value

	// Blank out the first cell of the argument
	#emit CONST.pri  0
	#emit SREF.S.pri address

	// Push the destination
	#emit PUSH.S     address

	// Push the number of parameters passed (in bytes) to the function.
	#emit PUSH.C     12

	// Call the function.
	#emit SYSREQ.C   strcat

	// Restore the stack to its level before we called this native.
	#emit STACK      16
	return 1;
}

stock static getstringarg(dest[], arg, len = sizeof (dest))
{
	// Get the address of the previous function's stack.  First get the index of
	// the argument required.
	#emit LOAD.S.pri arg
	// Then convert that number to bytes from cells.
	#emit SMUL.C     4
	// Get the previous function's frame.  Stored in variable 0 (in the current
	// frame).  Parameters are FRM+n+12, locals are FRM-n, previous frame is
	// FRM+0, return address is FRM+4, parameter count is FRM+8.  We could add
	// checks that "arg * 4 < *(*(FRM + 0) + 8)", for the previous frame parameter
	// count (in C pointer speak).
	#emit LOAD.S.alt 0
	// Add the frame pointer to the argument offset in bytes.
	#emit ADD
	// Add 12 to skip over the function header.
	#emit ADD.C      12
	// Load the address stored in the specified address.
	#emit LOAD.I
	// Push the length for "strcat".
	#emit PUSH.S     len
	// Push the address we just determined was the source.
	#emit PUSH.pri
	// Load the address of the destination.
	#emit LOAD.S.alt dest
	// Blank the first cell so "strcat" behaves like "strcpy".
	#emit CONST.pri  0
	// Store the loaded number 0 to the loaded address.
	#emit STOR.I
	// Push the loaded address.
	#emit PUSH.alt
	// Push the number of parameters passed (in bytes) to the function.
	#emit PUSH.C     12
	// Call the function.
	#emit SYSREQ.C   strcat
	// Restore the stack to its level before we called this native.
	#emit STACK      16
	return 1;
}