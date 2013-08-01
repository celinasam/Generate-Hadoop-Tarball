   <configuration>
    <srcPath prefix="hdfs://10.144.74.118:9000/user/hadoop/input">
      <policy name = "teste">
        <erasureCode>rs</erasureCode>
        <property>
          <name>srcReplication</name>
          <value>3</value>
          <description> pick files for RAID only if their replication factor is
                        greater than or equal to this value.
          </description>
        </property>
        <property>
          <name>targetReplication</name>
          <value>1</value>
          <description> after RAIDing, decrease the replication factor of a file to 
                        this value.
          </description>
        </property>
        <property>
          <name>metaReplication</name>
          <value>1</value>
          <description> the replication factor of the RAID meta file
          </description>
        </property>
        <property>
          <name>modTimePeriod</name>
          <value>3600000</value>
          <description> time (milliseconds) after a file is modified to make it a
                        candidate for RAIDing
          </description>
        </property>
      </policy>
    </srcPath>
   </configuration>

