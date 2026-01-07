import { Layout } from './components/Layout'
import { NordWidget } from './components/NordWidget'
import { FamigliaWidget } from './components/FamigliaWidget'
import { RoadmapWidget } from './components/RoadmapWidget'
import { SessioneWidget } from './components/SessioneWidget'

function App() {
  return (
    <Layout>
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
        <NordWidget />
        <FamigliaWidget />
      </div>
      <div className="mb-8">
        <RoadmapWidget />
      </div>
      <div className="mb-24">
        <SessioneWidget />
      </div>
    </Layout>
  )
}

export default App
