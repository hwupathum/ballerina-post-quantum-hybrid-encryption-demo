# Post-Quantum Hybrid Encryption Demo

Refer the article [Post-Quantum Hybrid Encryption with Ballerina](https://wso2.com/library/blogs/post-quantum-hybrid-encryption-ballerina/) for more information.

## Prerequisites

- Ballerina Swan Lake (Update 9 or later)
- Java Development Kit (JDK) 11 or later

## Running the Demo

### Running the Server

1. Navigate to the sample-server directory:

    ```bash
    cd sample-server
    ```

2. Modify the `Config.toml` file as needed. The default value for the password is `password`.

3. Run the Ballerina server:

    ```bash
    bal run
    ```

4. The service will be available at `http://localhost:9090`.

### Running the Client

1. Navigate to the sample-client directory:

    ```bash
    cd sample-client
    ```

2. Run the Ballerina client:

    ```bash
    bal run
    ```

## Key Generation (Optional)

### For RSA

1. Use the following command to create an RSA keystore:
```bash
keytool -genkeypair -alias alias -keyalg RSA -keystore rsa-keystore.jks -storepass password -keypass password -validity 365
```
2. Export the public key from the keystore:
```bash
keytool -export -alias alias -keystore rsa-keystore.jks -file rsa-cert.cer -storepass password
```

### For MLKEM

1. Clone this repository to your local machine:

    ```bash
    git clone https://github.com/hwupathum/kyber-keystore-gen.git
    ```

2. Navigate to the project directory:

    ```bash
    cd kyber-keystore-gen
    ```

3. Build the project using Maven:

    ```bash
    mvn clean install
    ```

4. Use the tool to generate and manage keystores for the Kyber algorithm:

    ```bash
    java -jar target/kyber-keystore-gen-1.0-SNAPSHOT.jar
    ```
5. Enter keystore name, alias and password when prompted.

    ```bash
    Enter keystore name: mlkem-keystore.p12
    Enter certificate alias: alias
    Enter Keystore Password: password
    Enter Keystore Password: password
    ```

6. Use the following command to export the public certificate of the generated keypair:

    ```bash
    openssl pkcs12 -in mlkem-keystore.p12 -clcerts -nokeys -out mlkem-cert.pem -alias alias
    ```

## Troubleshooting

If you encounter any issues, please check the following:
- Ensure that Ballerina and JDK are correctly installed.
- Verify the configuration in `Config.toml`.
