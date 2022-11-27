import { useCallback, useEffect, useMemo, useRef, useState } from 'react'
import styles from './styles.module.css'
import * as ethereum from '@/lib/ethereum'
import * as main from '@/lib/main'
import { BigNumber } from 'ethers'

const STATUS_FLOP = -2
const STATUS_TOUCHED = -1
const STATUS_BASICSHIP = 3
const STATUS_TITANIC = 4
type Canceler = () => void

const useAffect = (
  asyncEffect: () => Promise<Canceler | void>,
  dependencies: any[] = []
) => {
  const cancelerRef = useRef<Canceler | void>()
  useEffect(() => {
    asyncEffect()
      .then(canceler => (cancelerRef.current = canceler))
      .catch(error => console.warn('Uncatched error', error))
    return () => {
      if (cancelerRef.current) {
        cancelerRef.current()
        cancelerRef.current = undefined
      }
    }
  }, dependencies)
}

const useWindowSize = () => {
  const [size, setSize] = useState({ height: 0, width: 0 })
  const compute = useCallback(() => {
    const height = Math.min(window.innerHeight, 800)
    const width = Math.min(window.innerWidth, 800)
    if (height < width) setSize({ height, width: height })
    else setSize({ height: width, width })
  }, [])
  useEffect(() => {
    compute()
    window.addEventListener('resize', compute)
    return () => window.addEventListener('resize', compute)
  }, [compute])
  return size
}

const useWallet = () => {
  const [details, setDetails] = useState<ethereum.Details>()
  const [contract, setContract] = useState<main.Main>()
  useAffect(async () => {
    const details_ = await ethereum.connect('metamask')
    if (!details_) return
    setDetails(details_)
    const contract_ = await main.init(details_)
    if (!contract_) return
    setContract(contract_)
  }, [])
  return useMemo(() => {
    if (!details || !contract) return
    return { details, contract }
  }, [details, contract])
}

//type Ship = {}
interface Ship  {
  status: Number
}
const useBoard = (wallet: ReturnType<typeof useWallet>) => {
  const [board, setBoard] = useState<(null | Ship | Number)[][]>([])
  useAffect(async () => {
    if (!wallet) return
    const onRegistered = (
      id: BigNumber,
      owner: string,
      x: BigNumber,
      y: BigNumber
    ) => {
      console.log('onRegistered')
      setBoard(board => {
        return board.map((x_, index) => {
          if (index !== x.toNumber()) return x_
          return x_.map((y_, indey) => {
            if (indey !== y.toNumber()) return y_
            return { owner, index: id.toNumber(), status:1 } // todo add status (or id)for each ship ?
          })
        })
      })
    }
    const onTouched = (id: BigNumber, x_: BigNumber, y_: BigNumber) => {
      console.log('onTouched')
      console.log('onTouched', id, x_, y_)
      const x = x_.toNumber()
      const y = y_.toNumber()
      setBoard(board => {
        return board.map((x_, index) => {
          if (index !== x) return x_
          return x_.map((y_, indey) => {
            if (indey !== y) return y_
            return STATUS_TOUCHED
          })
        })
      }) 
    }
    const onFlop = (x_: BigNumber, y_: BigNumber) => {
      const x = x_.toNumber()
      const y = y_.toNumber()
      console.log('onFlop position ', x, y)
      setBoard(board => {
        return board.map((x_, index) => {
          if (index !== x) return x_
          else return x_.map((y_, indey) => {
            if (indey !== y) return y_
            else return STATUS_FLOP
          })
        })
      })
    }

    const updateSize = async () => {
      const [event] = await wallet.contract.queryFilter('Size', 0)
      const width = event.args.width.toNumber()
      const height = event.args.height.toNumber()
      const content = new Array(width).fill(0)
      const final = content.map(() => new Array(height).fill(null))
      setBoard(final)
    }
    const updateRegistered = async () => {
      const registeredEvent = await wallet.contract.queryFilter('Registered', 0)
      registeredEvent.forEach(event => {
        const { index, owner, x, y } = event.args
        onRegistered(index, owner, x, y)
      })
    }
    const updateTouched = async () => {
      const touchedEvent = await wallet.contract.queryFilter('Touched', 0)
      touchedEvent.forEach(event => {
        const { ship, x, y } = event.args
        onTouched(ship, x, y)
      })
    }
    const updateFlop = async () => {
      console.log("update Flop-------")
      const flopEvent = await wallet.contract.queryFilter('Flop', 0)
      flopEvent.forEach(event => {
        console.log("Update Flop 2")
        const { x, y } = event.args
        onFlop(x, y)
      })
	}
    await updateSize()
    await updateRegistered()
    await updateTouched()
    await updateFlop()
    console.log('Registering')
    wallet.contract.on('Registered', onRegistered)
    wallet.contract.on('Touched', onTouched)
    wallet.contract.on('Flop', onFlop)
    return () => {
      console.log('Unregistering')
      wallet.contract.off('Registered', onRegistered)
      wallet.contract.off('Touched', onTouched)
      wallet.contract.off('Flop', onFlop)
    }
  }, [wallet])
  return board
}

const Menu = () => {
  return (
    <div style={{ display: 'flex', gap: 5, padding: 5 }}>
          <p>Choisir une stratégie:</p>
          <select name="strats" id="strats">
            <option value="1" selected>Bateau basique</option>
            <option value="2">Bateau destroyer</option>
          </select>
          <br></br>
    </div>
  )
}

//var menuInput = document.getElementById("strats");
//var value = menuInput.value;

const Buttons = ({ wallet }: { wallet: ReturnType<typeof useWallet> }) => {
  const reg = () => wallet?.contract.register2()
  const next = () => {console.log("Turn Called"); wallet?.contract.turn()}
    return (
    <div style={{ display: 'flex', gap: 5, padding: 5 }}>
      <button onClick={reg}>Register</button>
      <button onClick={next}>Turn</button>
    </div>
  )
}



const CELLS = new Array(100 * 100)
export const App = () => {
  const wallet = useWallet()
  const board = useBoard(wallet)
  const size = useWindowSize()
  const st = {
    ...size,
    gridTemplateRows: `repeat(${board?.length ?? 0}, 1fr)`,
    gridTemplateColumns: `repeat(${board?.[0]?.length ?? 0}, 1fr)`,
  }
  return (
    <div className={styles.body}>
      <h1>Welcome to Touché Coulé</h1>
      <div className={styles.grid} style={st}>
        {CELLS.fill(0).map((_, index) => {
          const x = Math.floor(index % board?.length ?? 0)
          const y = Math.floor(index / board?.[0]?.length ?? 0)

          if ( board?.[x]?.[y]) {console.log(board[x][y])}
          
          let getColor = (val:Number|Ship):string|undefined=>{
            if (typeof val === "number") { // flop
              if(val == STATUS_FLOP){
                console.log("Flop reussi");
                return 'black';
              }
              else if(val == STATUS_TOUCHED){
                return 'red';
              }
            }
            else return 'green' // couleur peut changer selon value.status
          }
          
          const background = board?.[x]?.[y] ? getColor(board?.[x]?.[y]!) : undefined
          /*
            // peux ajouter des images de bateaux si on a le temp
          if (board?.[x]?.[y]){

           return (
             <img key={index}  src="public/vite.svg" className={styles.cell} style={{ background }} />
             //  <img key={index}  src="public/vite.svg" className={styles.cell} style={{ background }} />
             
             )}else{
              */
               return (
              <div key={index} className={styles.cell} style={{ background }} />
             // <div key={index} className={styles.cell} style={{ background }} />
              
        )}
        )}
      </div>
      <div>
        <Menu/>
        <Buttons wallet={wallet}/>
      </div>
    </div>
  )
}
