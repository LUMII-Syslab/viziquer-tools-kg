import csv
import psycopg2
import os

from enum import Enum
from dotenv import load_dotenv
from pathlib import Path
import re

# Load environment variables from .env file
load_dotenv()

# HOST = "127.0.0.1"
# PORT = os.getenv('PORT')
# DATA_BASE_NAME = os.getenv('DATA_BASE_NAME')
# USER_NAME = os.getenv('USER_NAME')
# USER_PSW = os.getenv('USER_PSW')

# RDF_FILES = './GeneratedRDF/'
RDF_FILES = os.getenv('RDF_FILES')

# DB_SCHEMA_NAME = "abertosgaliciana"
# DB_SCHEMA_NAME = "nobel_prizes_simple"
# DB_SCHEMA_NAME = "mini_university"
DB_SCHEMA = os.getenv('DB_SCHEMA')

DB_URL = os.getenv('DB_URL')

# CLASS_MAPPINGS = 'Mappings.csv'
CLASS_MAPPINGS = os.getenv('CLASS_MAPPINGS', "Mappings.csv").strip() or "Mappings.csv"

# LINK_MAPPINGS = 'Mappings_links.csv'
LINK_MAPPINGS = os.getenv('LINK_MAPPINGS')

# RDF_SCHEMA_NS='http://schema.vq.app/'
RDF_SCHEMA_NS = os.getenv('RDF_SCHEMA_NS', "http://schema.vq.app/")

# OUTPUT_FILE = 'generated_rdf.nt'
OUTPUT_FILE = os.getenv('OUTPUT_FILE')

# CSV_FILE_DELIMITER = ','
CSV_FILE_DELIMITER = os.getenv('CSV_FILE_DELIMITER', ",").strip()


# expected to be TRUE or FALSE
GENERATE_R2RML_MAPPING = os.getenv('GENERATE_R2RML_MAPPING')

R2RML_TARGET_FILE = os.getenv('R2RML_TARGET_FILE', "mappings.ttl").strip() or "mappings.ttl"
       

def create_connection():
    # return psycopg2.connect(
    #         dbname=DATA_BASE_NAME,
    #         user=USER_NAME,
    #         password=USER_PSW,
    #         host=HOST,
    #         port=PORT
    #     )
    return psycopg2.connect(DB_URL)


def print_constants():
    print("Following constants are being used: ")
    print("  DB_SCHEMA_NAME=", DB_SCHEMA)
    # print("  HOST=",HOST)
    # print("  PORT=",PORT)
    # print("  DATA_BASE_NAME=",DATA_BASE_NAME)
    print("  DB_URL=",DB_URL)
    # print("  USER_NAME=",USER_NAME)
    # print("  USER_PSW=",USER_PSW)
    print("  CLASS_MAPPINGS=",CLASS_MAPPINGS)
    print("  LINK_MAPPINGS=",LINK_MAPPINGS)
    print("  RDF_SCHEMA_NS=",RDF_SCHEMA_NS)
    print("  OUTPUT_FILE=",OUTPUT_FILE)
    print("  CSV_FILE_DELIMITER=",CSV_FILE_DELIMITER)

    print("  GENERATE_R2RML_MAPPING=",GENERATE_R2RML_MAPPING)
    print("  R2RML_TARGET_FILE=",R2RML_TARGET_FILE)

    print()
    print()


class DataType(Enum):
    STRING = 'String'
    INTEGER = 'Integer'
    BOOLEAN = 'Boolean'
    DOUBLE = 'Double'

    @staticmethod
    def from_string(data_type_str):
        """
        Creates an enum member from a string.

        :param data_type_str: The string representation of the data type.
        :return: The corresponding DataType enum member, or raises ValueError if not found.
        """
        for data_type in DataType:
            if data_type.value == data_type_str:
                return data_type
        raise ValueError(f"'{data_type_str}' is not a valid DataType")

    def __str__(self):
        """
        Prints out the enum member.
        """
        print(f"DataType: {self.name}, Value: {self.value}")

class LinkMapping:
    def __init__(self, 
                sourceClassName, linkName, targetClassName, 
                sql_table_name, sql_column_name, sql_target_table_name
                ):
        
        self.sourceClassName = sourceClassName
        self.linkName = linkName
        self.targetClassName = targetClassName
        
        self.sql_table_name = sql_table_name
        self.sql_column_name = sql_column_name
        self.sql_target_table_name = sql_target_table_name
        
    def __repr__(self):
        return (f"LinkMapping(sourceClassName='{self.sourceClassName}', \n"
                f"linkName='{self.linkName}', \n"
                f"targetClassName='{self.targetClassName}', \n"
                f"sql_table_name='{self.sql_table_name}', \n"
                f"sql_column_name='{self.sql_column_name}')\n"
                f"sql_target_table_name='{self.sql_target_table_name}')\n")
    
    def generateLinkTriples(self, trg_file):
        # for each row in table sql_table_name create the following triple:
        # <<class1_Name>_<objID>> <linkName> <owl_class_name_<sql_column_id>>
        table_name = DB_SCHEMA + "." + self.sql_table_name
        try:
            # Connect to the PostgreSQL database
            connection = create_connection()
            cursor = connection.cursor()
            cursor.execute("SET search_path TO " + DB_SCHEMA)

            # Execute the query to fetch all records from the table
            
            self.sql_table_name = self.sql_table_name.strip()
            if self.sql_table_name.startswith("SELECT") or self.sql_table_name.startswith("select"):
                # ja table name satur select pieprasijumu - izmantojam to, citadi konstruejam select pasi
                query = self.sql_table_name
            else:
                query = f"SELECT id,  { self.sql_column_name } FROM {table_name} WHERE { self.sql_column_name } IS NOT NULL"


            cursor.execute(query)

            # Fetch all rows from the executed query
            records = cursor.fetchall()

            # with open(os.path.join(TRG_DIR_FOR_RDF_FILES,self.sourceClassName + "_"+self.linkName+".nt"), mode='w') as file:

            #     # Print the fetched records
            #     for record in records:
            #         print(record)
            #         print(record[0])

            #         res = LinkMapping.generate_link_triple(self.sourceClassName, record[0], self.linkName, self.targetClassName, record[1])
            #         file.write(res)
            
           
            for record in records:
                # print(record)
                # print(record[0])

                res = LinkMapping.generate_link_triple(self.sourceClassName, record[0], self.linkName, self.targetClassName, record[1])
                # file.write(res)
                add_triple_to_file(trg_file, res)

        except (Exception, psycopg2.Error) as error:
            print("Error while fetching data from PostgreSQL", error)

        finally:
            # Close the database connection
            if connection:
                cursor.close()
                connection.close()
                # print("PostgreSQL connection is closed")


    def generate_link_triple(sourceClassName, subjID, linkName, targetClassName, objID):
        return Class2Table.generate_rdf_id(subjID, sourceClassName) + " <" + RDF_SCHEMA_NS+linkName+"> " + Class2Table.generate_rdf_id(objID, targetClassName)+".\n"


# Class2Table represents two different kinds of mappings : mapping from class to table and mappping from attribute to column.
# We can distinguish class->table by the fact that only two fields, class_name and table_name, are filled - all the other fields will be empty.
class Class2Table:
    def __init__(self, 
                owl_URI_pattern,
                owl_class_name, owl_attribute_name, owl_attribute_type,
                #   owl_subclass_name,
                sql_table_specification, sql_column_name, 
                # sql_expr,
                is_class_to_table
                # , is_subclass_mapping
                ):
        
        self.owl_URI_pattern = owl_URI_pattern
        self.owl_class_name = owl_class_name
        self.owl_attribute_name = owl_attribute_name
        self.owl_attribute_type = owl_attribute_type
        # self.owl_subclass_name = owl_subclass_name
        
        self.sql_table_specification = sql_table_specification
        self.sql_column_name = sql_column_name
        # self.sql_expr = sql_expr

        self.is_class_to_table = is_class_to_table
        # self.is_subclass_mapping = is_subclass_mapping

    @staticmethod
    def generate_rdf_id(record_id, uri_pattern):
        return "<" + RDF_SCHEMA_NS + uri_pattern + "_" + str(record_id)+">"
    
    @staticmethod
    def generate_type_triple_with_pattern(uri_pattern, owl_class_name):
        return "<" + RDF_SCHEMA_NS + uri_pattern +">" + " <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> " + "<" +RDF_SCHEMA_NS + owl_class_name+ ">.\n"
    
    @staticmethod
    def generate_type_triple(record_id, uri_pattern, owl_class_name):
        return Class2Table.generate_rdf_id(record_id, uri_pattern) + " <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> " + "<" +RDF_SCHEMA_NS + owl_class_name+ ">.\n"

    @staticmethod
    def create_attr_val_str_repr( owl_attribute_type, attr_value):
        val_str_rep = "\"" + str(attr_value) + "\""
        
        if owl_attribute_type == "string":
            val_str_rep += "^^<http://www.w3.org/2001/XMLSchema#string>"
        elif owl_attribute_type == "integer":
            val_str_rep += "^^<http://www.w3.org/2001/XMLSchema#integer>"
        elif owl_attribute_type == "double":
            val_str_rep += "^^<http://www.w3.org/2001/XMLSchema#double>"
        elif owl_attribute_type == "boolean":
            # val_str_rep += "^^<http://www.w3.org/2001/XMLSchema#boolean>"
            val_str_rep = "\"" + str(attr_value).lower() + "\"" + "^^<http://www.w3.org/2001/XMLSchema#boolean>"
        elif owl_attribute_type == "URI":
            val_str_rep = "<"+attr_value+">"# if attr_type is URI, then we do not need type specifier for it 
        return val_str_rep
    

    @staticmethod
    def generate_attr_triple_with_pattern(uri_pattern, owl_attribute_name, owl_attribute_type, attr_value):
        val_str_rep = Class2Table.create_attr_val_str_repr(owl_attribute_type, attr_value)
        
        return "<" + RDF_SCHEMA_NS + uri_pattern +">" + " <" + RDF_SCHEMA_NS + owl_attribute_name +"> " + val_str_rep + ".\n"

    @staticmethod
    def generate_attr_triple(record_id, uri_pattern, owl_attribute_name, owl_attribute_type, attr_value):
        val_str_rep = Class2Table.create_attr_val_str_repr(owl_attribute_type, attr_value)

        return Class2Table.generate_rdf_id(record_id, uri_pattern) + " <" + RDF_SCHEMA_NS + owl_attribute_name +"> " + val_str_rep + ".\n"

    def generate_attribute_triples_old(self, trg_file):
        
        table_name = DB_SCHEMA + "." + self.sql_table_name
        # Classifier;displayName;string;Classes;display_name;;
        try:
            # Connect to the PostgreSQL database
            connection = create_connection()
            cursor = connection.cursor()

            # Execute the query to fetch all records from the table
            query = f"SELECT id, {self.sql_column_name} FROM {table_name} where {self.sql_column_name} IS NOT NULL"
            cursor.execute(query)

            # Fetch all rows from the executed query
            records = cursor.fetchall()

            # with open(os.path.join(TRG_DIR_FOR_RDF_FILES,self.owl_class_name +"_"+self.owl_attribute_name + "_attr.nt"), mode='w') as file:

            #     # Print the fetched records
            #     for record in records:
            #         print(record)
            #         print(record[0])

            #         res = Class2Table.generate_attr_triple(record[0], self.owl_class_name, self.owl_attribute_name, self.owl_attribute_type, record[1])
            #         file.write(res)
            
            for record in records:
                # print(record)
                # print(record[0])

                res = Class2Table.generate_attr_triple(record[0], self.owl_class_name, self.owl_attribute_name, self.owl_attribute_type, record[1])
                # file.write(res)
                add_triple_to_file(trg_file, res)

        except (Exception, psycopg2.Error) as error:
            print("Error while fetching data from PostgreSQL", error)

        finally:
            # Close the database connection
            if connection:
                cursor.close()
                connection.close()
                # print("PostgreSQL connection is closed")


    def generate_attribute_triples(self, trg_file):
        # Table specification can be in one of 2 forms: table name or sql select expression
        # Also there can be URI pattern
        # If URI pattern is present 

        # for each row in table sql_table_name create the following triple:
        # <objID> <rdf:type> <owl_class_name>
        table_name = DB_SCHEMA + "." + self.sql_table_specification
        try:
            # Connect to the PostgreSQL database
            connection = create_connection()
            cursor = connection.cursor()

            cursor.execute("SET search_path TO " + DB_SCHEMA)
            
            # remove wspaces at the start and end 
            self.sql_table_specification = self.sql_table_specification.strip()

            if self.sql_table_specification.startswith("select") or self.sql_table_specification.startswith("SELECT"):
                # query = self.sql_table_specification
                # select id, cnt from (select * from mini_university.classes where mini_university.classes.cnt>10) as a
                base_query = f"({self.sql_table_specification}) as a "

            else:
                # sql_table_name nebija sql select - tas ir vienkarsi tabulas vards
                base_query = f"(SELECT * FROM {table_name}) as a "
            
            # select id from query 
            # select id, var1,var2, var3 from query

            # skatamies vai bija izmantots URI patterns 
            URI_pattern_used = self.owl_URI_pattern is not None and len(self.owl_URI_pattern)>0 and "{" in self.owl_URI_pattern
            var_name_to_index = {}
            if URI_pattern_used:
                # formejam  pieprasijumu, kas satur visus mainigos, kas tiek izmantoti šablona + id
                vars = extract_variables_with_formatter(self.owl_URI_pattern)
                if 'id' in vars or 'ID' in vars:
                    vars.discard('id')
                    vars.discard('ID')
                
                res_query = "SELECT id, " + self.sql_column_name
                
                i=0
                var_name_to_index['id'] = i
                i=1
                var_name_to_index[self.sql_column_name] = i
                
                vars.discard(self.sql_column_name) # lai neparaditos 2 reizes
                
                for var in vars:
                    res_query += ", " + var
                    
                    i+=1
                    var_name_to_index[var] = i
                
                res_query += " FROM " + base_query
                
            else:
                # formejam  pieprasijumu, kas satur TIKAI id un column_name
                res_query = "SELECT id, "+ self.sql_column_name+" FROM " + base_query 
                i=0
                var_name_to_index['id'] = i
                i=1
                var_name_to_index[self.sql_column_name] = i


            res_query += " WHERE " + self.sql_column_name + " IS NOT NULL"
            cursor.execute(res_query)

            # Fetch all rows from the executed query
            records = cursor.fetchall()

            # with open(os.path.join(TRG_DIR_FOR_RDF_FILES,self.owl_class_name + "_type.nt"), mode='w') as file:

            #     # Print the fetched records
            #     for record in records:
            #         print(record)
            #         print(record[0])

            #         res = Class2Table.generate_type_triple(record[0], self.owl_class_name)
            #         file.write(res)
            
            # with open(os.path.join(TRG_DIR_FOR_RDF_FILES,self.owl_class_name + "_type.nt"), mode='w') as file:


            for record in records:
                # print(record)
                # print(record[0]) #id
                
                if URI_pattern_used:
                    vars = extract_variables_with_formatter(self.owl_URI_pattern)
                    # vars.discard('id')
                    # vars.discard('ID') - nevajag mest ara, jo id ar var paradities sablona

                    # izveidot map ar var, value
                    var_vals = {}
                    for var in vars:
                        var_vals[var] = record[ var_name_to_index[var] ]
                    
                    processed_uri_pattern = self.owl_URI_pattern
                    processed_uri_pattern = process_custom_fstring(processed_uri_pattern, var_vals)
                    
                    res = Class2Table.generate_attr_triple_with_pattern(processed_uri_pattern, self.owl_attribute_name, self.owl_attribute_type, record[1])
                else:
                    res = Class2Table.generate_attr_triple(record[0], self.owl_URI_pattern, self.owl_attribute_name, self.owl_attribute_type, record[1])
                
                # bija ieks vecas versijas
                # res = Class2Table.generate_attr_triple(record[0], self.owl_class_name, )
                add_triple_to_file(trg_file, res)


        except (Exception, psycopg2.Error) as error:
            print("Error while fetching data from PostgreSQL", error)

        finally:
            # Close the database connection
            if connection:
                cursor.close()
                connection.close()
                # print("PostgreSQL connection is closed")

    def generate_class_type_triples(self, trg_file):
        # Table specification can be in one of 2 forms: table name or sql select expression
        # Also there can be URI pattern
        # If URI pattern is present 

        # for each row in table sql_table_name create the following triple:
        # <objID> <rdf:type> <owl_class_name>
        table_name = DB_SCHEMA + "." + self.sql_table_specification
        try:
            # Connect to the PostgreSQL database
            connection = create_connection()
            cursor = connection.cursor()

            cursor.execute("SET search_path TO " + DB_SCHEMA)
            
            # remove wspaces at the start and end 
            self.sql_table_specification = self.sql_table_specification.strip()

            if self.sql_table_specification.startswith("select") or self.sql_table_specification.startswith("SELECT"):
                # query = self.sql_table_specification
                # select id, cnt from (select * from mini_university.classes where mini_university.classes.cnt>10) as a
                base_query = f"({self.sql_table_specification}) AS a"

            else:
                # sql_table_name nebija sql select - tas ir vienkarsi tabulas vards
                base_query = f"(SELECT * FROM {table_name}) AS a"
            
            # konstruejam pieprasijumu, kas bus sekojosa forma:
            # select id from base_query 
            # select id, var1,var2, var3 from base_query

            # skatamies vai bija izmantots URI patterns 
            URI_pattern_used = self.owl_URI_pattern is not None and len(self.owl_URI_pattern)>0 and "{" in self.owl_URI_pattern
            var_name_to_index = {}
            if URI_pattern_used:
                # formejam  pieprasijumu, kas satur visus mainigos, kas tiek izmantoti šablona + id
                vars = extract_variables_with_formatter(self.owl_URI_pattern)
                if 'id' in vars or 'ID' in vars:
                    vars.discard('id')
                    vars.discard('ID')
                
                res_query = "SELECT id "
                
                i=0
                var_name_to_index['id'] = i
                
                for var in vars:
                    res_query += ", " + var
                    
                    i+=1
                    var_name_to_index[var] = i
                
                res_query += " FROM " + base_query
                
            else:
                # formejam  pieprasijumu, kas satur TIKAI id
                # TODO parrakstit lai nebut si else dala  - ta nav vajadziga jo jebkura gdijuma  id bus mainigo saraksta
                i=0
                var_name_to_index['id'] = i
                res_query = "SELECT id FROM " + base_query 


            cursor.execute(res_query)

            # Fetch all rows from the executed query
            records = cursor.fetchall()

            # with open(os.path.join(TRG_DIR_FOR_RDF_FILES,self.owl_class_name + "_type.nt"), mode='w') as file:

            #     # Print the fetched records
            #     for record in records:
            #         print(record)
            #         print(record[0])

            #         res = Class2Table.generate_type_triple(record[0], self.owl_class_name)
            #         file.write(res)
            
            # with open(os.path.join(TRG_DIR_FOR_RDF_FILES,self.owl_class_name + "_type.nt"), mode='w') as file:


            for record in records:
                # print(record)
                # print(record[0]) #id
                
                if URI_pattern_used:
                    vars = extract_variables_with_formatter(self.owl_URI_pattern)
                    # vars.discard('id')
                    # vars.discard('ID')

                    # izveidot map ar var, value
                    var_vals = {}
                    for var in vars:
                        var_vals[var] = record[ var_name_to_index[var] ]
                    
                    processed_uri_pattern = self.owl_URI_pattern
                    processed_uri_pattern = process_custom_fstring(processed_uri_pattern, var_vals)
                    
                    res = Class2Table.generate_type_triple_with_pattern(processed_uri_pattern, self.owl_class_name)
                else:
                    res = Class2Table.generate_type_triple(record[0], self.owl_URI_pattern, self.owl_class_name)
                
                add_triple_to_file(trg_file, res)


        except (Exception, psycopg2.Error) as error:
            print("Error while fetching data from PostgreSQL", error)

        finally:
            # Close the database connection
            if connection:
                cursor.close()
                connection.close()
                # print("PostgreSQL connection is closed")


    def generate_triples_for_one_subclass(self, trg_file):
        # table_name = DB_SCHEMA_NAME + "." + sub_cl_map['sql_table_name']
        try:
            # Connect to the PostgreSQL database
            connection = create_connection()
            cursor = connection.cursor()

            # Execute the query to fetch all records from the table
            # query = f"SELECT id FROM {table_name} where {subcl['where_expr']}"
            cursor.execute("SET search_path TO " + DB_SCHEMA)
            print(self.sql_expr)
            cursor.execute(self.sql_expr)

            # Fetch all rows from the executed query
            records = cursor.fetchall()

            # with open(subcl['name'] + "_type.nt", mode='w') as file:
            # with open(os.path.join(TRG_DIR_FOR_RDF_FILES,self.owl_subclass_name + "_type.nt"), mode='w') as file:

            #     # Print the fetched records
            #     for record in records:
            #         print(record)
            #         print(record[0])

            #         res = Class2Table.generate_type_triple(record[0], self.owl_subclass_name)
            #         file.write(res)
            


            # Print the fetched records
            for record in records:
                print(record)
                print(record[0])

                res = Class2Table.generate_type_triple(record[0], self.owl_subclass_name)
                add_triple_to_file(trg_file, res)

        except (Exception, psycopg2.Error) as error:
            print("Error while fetching data from PostgreSQL", error)

        finally:
            # Close the database connection
            if connection:
                cursor.close()
                connection.close()
                print("PostgreSQL connection is closed")


    def __repr__(self):
        return (f"Class2Table("
                f"\towl_URI_pattern='{self.owl_URI_pattern}',\n"
                f"\towl_class_name='{self.owl_class_name}',\n"
                f"\towl_attribute_name='{self.owl_attribute_name}',\n"
                f"\towl_attribute_type='{self.owl_attribute_type}',\n"
                # f"\towl_subclass_name='{self.owl_subclass_name}', \r\n"
                f"\tsql_table_specification='{self.sql_table_specification}',\n"
                f"\tsql_column_name='{self.sql_column_name}')\n"
                # f"\tsql_expr='{self.sql_expr}')\r\n"
                f"\tis_class_to_table='{self.is_class_to_table}'\n"
                # f"\tis_subclass_mapping='{self.is_subclass_mapping}')\r\n"
                f")"
                )



def load_class_mappings(file_path):
    mappings = []

    with open(file_path, mode='r') as file:
        # csv_reader = csv.reader(file, delimiter=';')
        csv_reader = csv.reader(file, delimiter=CSV_FILE_DELIMITER)
        
        # Skip the header row
        next(csv_reader)

        current_class = None
        current_table = None
        owl_URI_pattern = None

        for row in csv_reader:
            # print(row)
            
            owl_attribute_name = None
            owl_attribute_type = None
            # owl_subclass_name = None
            # sql_table_name = None
            sql_column_name = None
            # sql_expr = None
            isClass2Table = False
            # isSubClassMapping = False
            
            if len(row[0]) == 0 and len(row[1]) == 0 and len(row[2]) == 0 and len(row[3]) == 0 and len(row[4]) == 0 and len(row[5])==0:
                #we are skipping this line - it is empty
                continue

            if row[1] and len(row[1])>0:  # Non-empty first element indicates type mapping or attribute mapping
                # print("<a>")
                # print(row[0])
                # print("</a>")
                
                # typ mappings values are in filled in 0,1,4
                # attr mapping - values are in filled in 2,3,4,5
                # class mapping - values are in filled in 1,4

                # if row[1] and len(row[1]) and row[4] and len(row[4]):#it is subclass mappings
                    # current_class = row[0]
                    # owl_subclass_name = row[1]
                    # sql_expr = row[4]
                    # # isSubClassMapping = True
                # else:
                
                owl_URI_pattern = row[0]
                current_class = row[1]
                current_table = row[4]
                isClass2Table = True
                # print(isClass2Table)
            
            else:  # Empty first element indicates attribute mapping
                owl_attribute_name = row[2]
                owl_attribute_type = row[3]
                sql_table_name = row[4]
                sql_column_name = row[5]
            
            # print(isClass2Table)
            mapping = Class2Table(  owl_URI_pattern,
                                    current_class,
                                    owl_attribute_name, owl_attribute_type, 
                                    # owl_subclass_name,
                                    current_table, sql_column_name, 
                                    # sql_expr,
                                    isClass2Table
                                    # , isSubClassMapping
                                    )
            # print(mapping)
            mappings.append(mapping)

    return mappings


def load_link_mappings(file_path):
    mappings = []

    with open(file_path, mode='r') as file:
        # csv_reader = csv.reader(file, delimiter=';')
        csv_reader = csv.reader(file, delimiter=CSV_FILE_DELIMITER)
        
        # Skip the header row
        next(csv_reader)
        
        for row in csv_reader:
            # print(row)
            sourceClassName = None
            linkName = None
            targetClassName = None
            
            sql_table_name = None
            sql_column_name = None
            sql_target_table_name = None
            
            if (len(row[0]) == 0 and len(row[1]) == 0 and len(row[2]) == 0 and len(row[3]) == 0 and 
                len(row[4]) == 0 and len(row[5]) == 0 and len(row[6]) == 0):
                #we are skipping this line - it is empty
                continue
            
            sourceClassName = row[0]
            linkName = row[1]
            targetClassName = row[2]

            sql_table_name = row[4]
            sql_column_name = row[5]
            sql_target_table_name = row[6]
            
            mapping = LinkMapping(sourceClassName, linkName, targetClassName,
                                sql_table_name,sql_column_name, sql_target_table_name)
            mappings.append(mapping)

    return mappings

#   {
#         "super_class":"ClassClassRel",
#         "sql_table_name": "cc_rels"
#         "sub_classes":[
#             {"name":"SubClass",
#              "where_expr" : "type_id = 1"},
#             {"name":"EqClass",
#              "where_expr" : "type_id = 2"}
#         ]
#     },

def generate_triples_for_one_subclass(sub_cl_map, subcl):
    table_name = DB_SCHEMA + "." + sub_cl_map['sql_table_name']
    try:
        # Connect to the PostgreSQL database
        connection = create_connection()
        cursor = connection.cursor()

        # Execute the query to fetch all records from the table
        query = f"SELECT id FROM {table_name} where {subcl['where_expr']}"
        cursor.execute(query)

        # Fetch all rows from the executed query
        records = cursor.fetchall()

        
        with open(os.path.join(RDF_FILES, subcl['name'] + "_type.nt"), mode='w') as file:

            # Print the fetched records
            for record in records:
                print(record)
                print(record[0])

                res = Class2Table.generate_type_triple(record[0], subcl['name'])
                file.write(res)

    except (Exception, psycopg2.Error) as error:
        print("Error while fetching data from PostgreSQL", error)

    finally:
        # Close the database connection
        if connection:
            cursor.close()
            connection.close()
            print("PostgreSQL connection is closed")


def generate_subclass_type_triples():
    for sub_cl_map in subclass_mappings:
        print(sub_cl_map)
        for subcl in sub_cl_map['sub_classes']:
            generate_triples_for_one_subclass(sub_cl_map, subcl)


# Instances of class Tag are created from rows in two tables: property_annots, class_anots. 
# Now we traverse rows of the property_annots class.
# TODO: superclass links to Entity need to be added."

#TODO: not finished, additional testing is needed
def generateTriplesForTag():
    class_table_name = DB_SCHEMA + "." + "class_annots"
    try:
        # Connect to the PostgreSQL database
        
        connection = create_connection()
        cursor = connection.cursor()

        # Execute the query to fetch all records from the table
        query = f"SELECT id, annotation, language_code FROM {class_table_name}"
        cursor.execute(query)

        # Fetch all rows from the executed query
        records = cursor.fetchall()

        with open("Tag_class_anots_type.nt", mode='w') as file:

            # Print the fetched records
            for record in records:
                print(record)
                print(record[0])

                res =  "<http://myschema.org/Tag_classs_annots_" +  str(record[0]) + "> " + " <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> " +  " <http://myschema.org/Tag>.\n" 
                #TODO:generate triple for annotation, language_code
                file.write(res)
                #TODO:generate triple for annotation,
                res =  "<http://myschema.org/Tag_class_annots_" + str(record[0]) + "> " + " <http://myschema.org/value> \"" + str(record[1])+"\"^^<http://www.w3.org/2001/XMLSchema#string>.\n"
                file.write(res)
                #TODO:generate triple for language_code
                res =  "<http://myschema.org/Tag_class_annots_" + str(record[0]) + "> " + " <http://myschema.org/language> \"" + str(record[2])+"\"^^<http://www.w3.org/2001/XMLSchema#string>.\n"
                file.write(res)

    except (Exception, psycopg2.Error) as error:
        print("Error while fetching data from PostgreSQL", error)

    finally:
        # Close the database connection
        if connection:
            cursor.close()
            connection.close()
            print("PostgreSQL connection is closed")


def add_triple_to_file(file, triple):
    file.write(triple)

def test_alliases_in_cursors():
    connection = create_connection()
    cursor = connection.cursor()

    # Execute the query to fetch all records from the table
    cursor.execute("SET search_path TO " + DB_SCHEMA)
    # query = f"SELECT id FROM {table_name} where {self.sql_column_name} IS NOT NULL"
    query = "select id, cnt from (select * from classes where cnt>10) as a"
    cursor.execute(query)

    # Fetch all rows from the executed query
    records = cursor.fetchall()

    # with open(os.path.join(TRG_DIR_FOR_RDF_FILES,self.owl_class_name +"_"+self.owl_attribute_name + "_attr.nt"), mode='w') as file:

    #     # Print the fetched records
    #     for record in records:
    #         print(record)
    #         print(record[0])

    #         res = Class2Table.generate_attr_triple(record[0], self.owl_class_name, self.owl_attribute_name, self.owl_attribute_type, record[1])
    #         file.write(res)
    
    for record in records:
        print(record)
        print(record[0])

import string

def extract_variables_with_formatter(template):
    """
    Extract variable names from a template string using string.Formatter.

    Args:
        template (str): The template string (e.g., "Hello, {name}!").

    Returns:
        set: A set of variable names (e.g., {"name"}).
    """
    formatter = string.Formatter()
    return {field_name for _, field_name, _, _ in formatter.parse(template) if field_name}


def process_custom_fstring(template, variables):
    """
    Replace placeholders in a template string with values from a dictionary.

    Args:
        template (str): The template string with placeholders (e.g., "Hello, {name}!").
        variables (dict): A dictionary mapping variable names to their values.

    Returns:
        str: The resulting string with placeholders replaced by their corresponding values.
    """
    # Extract variables from the template
    used_variables = extract_variables_with_formatter(template)
    
    # Check for missing variables
    for var in used_variables:
        if var not in variables:
            raise ValueError(f"Missing value for variable: {var} in {template}")
    
    # Replace placeholders with their values
    result = template
    for var_name, value in variables.items():
        placeholder = f"{{{var_name}}}"
        result = result.replace(placeholder, str(value))
    
    return result

def test_var_extraction():
    # Example usage
    # template = "Hello, {name}! You have {count} new messages."
    # template = "Classifier_{id}"
    template = "{URI}"

    variables = extract_variables_with_formatter(template)
    print(variables)

def test_template_substitution():
    template = "Hello, {name}! You have {count} new messages and your score is {score}."
    variables = {"name": "Alice", "count": 5, "score": 92}
    used_vars = extract_variables_with_formatter(template)
    print(f"Variables used in template: {used_vars}")

    # Process the template
    output = process_custom_fstring(template, variables)
    print(output)


# test_var_extraction()
# test_template_substitution()
# exit()
# test_alliases_in_cursors()
# exit()

# if not os.path.exists(RDF_FILES):
#     os.makedirs(RDF_FILES)
#     print("Directory ", RDF_FILES, " has been created.")
#     print()
# else:
#     print("Using ", RDF_FILES , " as target directory for rdf files.")
#     print()

# ----------------------------------------------------------------------------------------------------------------------------
# R2RML ģenerators no Mappings.csv
# ----------------------------------------------------------------------------------------------------------------------------

def _normalize_xsd(dt: str) -> str:
    if not dt:
        return "string"
    dt = dt.strip().lower()
    table = {
        "str": "string",
        "string": "string",
        "text": "string",
        "int": "integer",
        "integer": "integer",
        "bool": "boolean",
        "boolean": "boolean",
        "double": "double",
        "float": "double",
        "decimal": "double",
        "date": "date",
        "datetime": "dateTime",
        "uri": "URI",
    }
    return table.get(dt, dt)


def _is_sql_query(table_expr: str) -> bool:
    return bool(table_expr) and table_expr.strip().lower().startswith("select")


def _read_mappings_csv(csv_path):
    """
    Nolasa CSV ar kolonnām:
    [0] URI pattern part
    [1] Class
    [2] Property
    [3] DataType
    [4] Table
    [5] Column

    Atgriež bloku sarakstu: katrs bloks = klase + tās īpašības.
    Katrai vienībai pievieno 'line' lauku (1-based).
    """
    blocks = []
    current = None

    

    with open(csv_path, "r", encoding="utf-8") as f:
        reader = csv.reader(f, delimiter=CSV_FILE_DELIMITER)

        # vienkārši izlaižam pirmo (header) rindu
        header = next(reader, None)

        line_no = 1  # sākam skaitīt no 2. rindas (jo 1. ir header)
        for row in reader:
            line_no += 1

            # izlaidām pilnīgi tukšas rindas
            if not row or all((c is None or str(c).strip() == "") for c in row):
                continue

            # droši paņemam 6 laukus
            vals = (row + [""] * 6)[:6]
            uri_part, cls, prop, dtype, table_expr, column = [v.strip() for v in vals]

            # ja ir klase -> jauns bloks
            if cls:
                current = {
                    "line": line_no,
                    "uri_pattern": uri_part,
                    "class_name": cls,
                    "table_expr": table_expr,
                    "is_sql": _is_sql_query(table_expr),
                    "properties": [],
                }
                blocks.append(current)
            else:
                if current is None:
                    print(f"[R2RML][WARN] Property rinda bez iepriekšējas klases (CSV rinda {line_no}). Ignorēju.")
                    continue
                current["properties"].append({
                    "line": line_no,
                    "name": prop,
                    "datatype": _normalize_xsd(dtype),
                    "table_expr": table_expr,
                    "column": column,
                })
    return blocks


def generate_r2rml_mappings(target_file: str,
                            csv_path: str = None,
                            rdf_schema_ns: str = None) -> None:
    """
    Ģenerē R2RML mappingu no Mappings.csv un saglabā failā target_file.

    Funkcionalitāte:
    - nolasām CSV, grupējam klases un īpašības;
    - ja 'Table' ir 'SELECT * ...', aizstājam ar minimālo kolonu sarakstu (id + property kolonnas);
    - subjekts tiek ģenerēts ar rr:template "NS + URI pattern + _{id}";
    - pie katra TriplesMap un property ierakstām komentāru ar CSV rindas numuru.
    """

    from pathlib import Path
    import os, csv, re

    # --- iestatījumi no .env ---
    subject_id_column = os.getenv("SUBJECT_ID_COLUMN", "id")
    delimiter = os.getenv("CSV_DELIMITER", ",").strip() or ","
    csv_path = csv_path or os.getenv("CLASS_MAPPINGS", "Mappings.csv")
    rdf_schema_ns = (rdf_schema_ns or os.getenv("RDF_SCHEMA_NS", "http://schema.vq.app/")).rstrip("/") + "/"

    # --- drošības pārbaudes ---
    csv_file = Path(csv_path)
    if not csv_file.exists():
        print(f"[R2RML][ERROR] CSV nav atrasts: {csv_file}")
        return

    print(f"[R2RML] Lasu mappingus no: {csv_file.resolve()}")

    # --- nolasām CSV ---
    blocks = []
    current = None
    with open(csv_file, "r", encoding="utf-8-sig", newline="") as f:
        reader = csv.reader(f, delimiter=delimiter)
        header = next(reader, None)  # vienkārši izlaižam virsrakstu rindu
        line_no = 1
        for row in reader:
            line_no += 1
            if not row or all(str(c).strip() == "" for c in row):
                continue
            vals = (row + [""] * 6)[:6]
            uri_part, cls, prop, dtype, table_expr, column = [v.strip() for v in vals]

            # jaunas klases sākums
            if cls:
                current = {
                    "line": line_no,
                    "uri_pattern": uri_part,
                    "class_name": cls,
                    "table_expr": table_expr,
                    "is_sql": bool(table_expr.lower().startswith("select")),
                    "properties": []
                }
                blocks.append(current)
            elif current:
                current["properties"].append({
                    "line": line_no,
                    "name": prop,
                    "datatype": dtype.strip().lower() or "string",
                    "column": column
                })

    if not blocks:
        print("[R2RML][WARN] CSV ir tukšs — nekas netika ģenerēts.")
        return

    # --- sākam TTL failu ---
    lines = [
        "@prefix rr:   <http://www.w3.org/ns/r2rml#> .",
        "@prefix xsd:  <http://www.w3.org/2001/XMLSchema#> .",
        f"@prefix :     <{rdf_schema_ns}> .",
        ""
    ]

    tm_counter = 0

    for block in blocks:
        tm_counter += 1
        cls = block["class_name"]
        tm_id = f"<#TM_{re.sub(r'[^A-Za-z0-9_]', '_', cls)}_{tm_counter}>"

        # --- loģiskā tabula (SQL apstrāde) ---
        table_expr = block["table_expr"].strip()
        if block["is_sql"] and re.match(r"(?i)^select\s+\*\s+from\s+", table_expr):
            # savācam kolonnas
            needed_cols = {subject_id_column}
            needed_cols.update(p["column"] for p in block["properties"] if p.get("column"))
            cols_sql = ", ".join(sorted(needed_cols))
            table_expr = re.sub(r"(?i)^select\s+\*\s+", f"SELECT {cols_sql} ", table_expr)

        # --- TriplesMap sākums ---
        lines.append(f"# --- from {csv_file.name} line {block['line']} ---")
        lines.append(f"{tm_id}")
        lines.append("  a rr:TriplesMap ;")

        if block["is_sql"]:
            lines.append(f'  rr:logicalTable [ rr:sqlQuery "{table_expr}" ] ;')
        else:
            lines.append(f'  rr:logicalTable [ rr:tableName "{table_expr}" ] ;')

        # --- subjekts ar rr:template ---
        lines.append("  rr:subjectMap [")
        lines.append(f'    rr:template "{rdf_schema_ns}{block["uri_pattern"]}_{{{subject_id_column}}}" ;')
        lines.append(f"    rr:class <{rdf_schema_ns}{cls}>")
        lines.append("  ] ;")

        # --- īpašības ---
        for p in block["properties"]:
            if not p["name"]:
                continue
            dt = p["datatype"]
            name = p["name"]
            col = p["column"]
            lines.append("  rr:predicateObjectMap [")
            lines.append(f'#   source {csv_file.name} line {p["line"]}: Property={name}, DataType={dt}, Column={col}')
            lines.append(f"    rr:predicate <{rdf_schema_ns}{name}> ;")
            if dt.lower() == "uri":
                lines.append("    rr:objectMap [")
                lines.append(f'      rr:column "{col}" ;')
                lines.append("      rr:termType rr:IRI")
                lines.append("    ]")
            else:
                lines.append("    rr:objectMap [")
                lines.append(f'      rr:column "{col}" ;')
                lines.append(f"      rr:datatype xsd:{dt.lower()}")
                lines.append("    ]")
            lines.append("  ] ;")

        # --- aizveram bloku ---
        if lines[-1].endswith(";"):
            lines[-1] = lines[-1][:-1] + " ."
        lines.append("")

    # --- rakstām failā ---
    target = Path(target_file)
    target.write_text("\n".join(lines), encoding="utf-8")
    print(f"[R2RML] OK — uzģenerēts {len(blocks)} TriplesMaps -> {target.resolve()}")

if __name__ == "__main__":    
    
    print_constants()

    if GENERATE_R2RML_MAPPING and GENERATE_R2RML_MAPPING.lower() == 'true':
    
        generate_r2rml_mappings(
            target_file=R2RML_TARGET_FILE,
            csv_path=CLASS_MAPPINGS,
            rdf_schema_ns=RDF_SCHEMA_NS
        )
        
    else:    

        trg_out_file = open(OUTPUT_FILE, mode='w', encoding="utf-8")

        
        print("Loading class mappings ...")
        mappings = load_class_mappings(CLASS_MAPPINGS)
        print("Loading class mappings - done")
        print("Loading link mappings ...")
        linkMappings = load_link_mappings(LINK_MAPPINGS)
        print("Loading link mappings - done")

        print("Processing class mappings ...")
        for mapping in mappings:
            # print(mapping)
            # print()
            if mapping.is_class_to_table:
                # pass
                # print(mapping)
                # print()
                mapping.generate_class_type_triples(trg_out_file)
            # elif mapping.is_subclass_mapping:
                # mapping.generate_triples_for_one_subclass(trg_out_file)
            else:
                # print(mapping)
                # print()
                mapping.generate_attribute_triples(trg_out_file)
        print("Processing class mappings - done.")

        print("Processing link mappings ...")
        for lm in linkMappings:
            # print(lm)
            lm.generateLinkTriples(trg_out_file)
        print("Processing link mappings - done.")
        # generateTriplesForTag()


        # m = Class2Table("Classifier", None, None, "Classes", None, True)
        # m.generate_class_type_triples()

        # m = Class2Table("Classifier", "instanceCount", "integer", "Classes", "cnt", False)
        # m.generate_attribute_triples()


