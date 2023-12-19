import requests
from requests.auth import HTTPBasicAuth

# OpenSearch endpoint and credentials
opensearch_url = "http://your-opensearch-host:9200"
username = "your-username"
password = "your-password"

# API endpoint for fetching roles
roles_endpoint = f"{opensearch_url}/_opendistro/_security/api/roles"

# List of role names to fetch
roles_to_fetch = ["role1", "role2", "role3"]

# Function to fetch specific roles
def fetch_specific_roles():
    try:
        # Make a GET request to the roles endpoint
        response = requests.get(roles_endpoint, auth=HTTPBasicAuth(username, password))

        # Check if the request was successful (status code 200)
        if response.status_code == 200:
            roles_data = response.json()

            # Filter roles based on the list
            specific_roles = {role_name: roles_data.get(role_name) for role_name in roles_to_fetch}

            return specific_roles
        else:
            print(f"Error: {response.status_code} - {response.text}")
            return None
    except Exception as e:
        print(f"An error occurred: {e}")
        return None

# Example usage
if __name__ == "__main__":
    specific_roles_data = fetch_specific_roles()

    if specific_roles_data:
        # Display specific roles
        print("Specific Roles:")
        for role_name, role_info in specific_roles_data.items():
            print(f"{role_name}: {role_info}")
    else:
        print("Failed to fetch specific roles.")
