pragma solidity^0.4.25;
contract HouseTransfer{
    
    event NewHouse(address owner,bytes name);
    event HouseNotFound();
    event HouseTransfered(address from,address to,uint256 number,string info);
    
    //房产的属性结构
    struct House{
        bytes name; //姓名
        bool isSold; //是否卖出
    }
    
    address admin; //管理员
    uint256 public totalHouses;//房产总数
    uint256 constant NOT_FOUND_OR_SOLD = 999999; //自定义固定数，用于判断
    mapping(address => House[]) public houseOf; //房产所有者
    
    constructor()public{
        admin = msg.sender; //初始化部署者为管理员
    }
    //函数修饰器，限制只能管理员调用
    modifier adminOnly{
        require(msg.sender == admin, "Admin require");
        _;
    }
    
    //房产产权分配
    function NewHouseFor(address newOwner,bytes memory name)public adminOnly{
        houseOf[newOwner].push(House(name,false));
        totalHouses ++;
        emit NewHouse(newOwner, name);
    }
    
    //检查房产所有权，返回索引值
    function checkOwner(address owner,bytes memory name)public view returns(uint256){
        //遍历房产产权数组
        for (uint256 i = 0 ; i < houseOf[owner].length; i++){
            //keccak256判断name是否相同
            if(keccak256(houseOf[owner][i].name) == keccak256(name) && !houseOf[owner][i].isSold)
                return i;
        }
        return NOT_FOUND_OR_SOLD;
    }
    
    //房产转让
    function transferHouse(address to,bytes memory name)public returns(bool){
        //查询房产，返回索引值
        uint256 i = checkOwner(msg.sender,name);
        if(i == NOT_FOUND_OR_SOLD){
            emit HouseNotFound();
            return false;
        }
        
        //更新相关房产信息
        houseOf[msg.sender][i].isSold = true;
        houseOf[msg.sender][i].name = "Sold!";
        
        //买家名下的房产列表增加一项
        houseOf[to].push(House(name,false));
        
        emit HouseTransfered(msg.sender, to , i , "House sold!");
    }
}